#!/usr/bin/env python3
"""Demostración ejecutable de transactional outbox, redelivery e inbox.

El ejemplo usa memoria, pero conserva las fronteras conceptuales:
1) estado de negocio + fila outbox en una transacción local;
2) relay at-least-once que puede repetir por ACK perdido;
3) consumidor con inbox/event_id atómico con su efecto;
4) saga durable simplificada con compensaciones idempotentes.
"""
from dataclasses import dataclass, field
from typing import Any


@dataclass
class LocalDB:
    orders: dict[str, dict[str, Any]] = field(default_factory=dict)
    outbox: dict[str, dict[str, Any]] = field(default_factory=dict)

    def create_order_and_event(self, order_id: str, event_id: str) -> None:
        """Representa una sola transacción local."""
        if order_id in self.orders:
            return
        self.orders[order_id] = {"status": "CREATED"}
        self.outbox[event_id] = {
            "event_id": event_id,
            "aggregate_id": order_id,
            "type": "OrderCreated",
            "published": False,
        }
        print(f"TX local COMMIT: order={order_id} + outbox={event_id}")


@dataclass
class Broker:
    records: list[dict[str, Any]] = field(default_factory=list)

    def publish(self, event: dict[str, Any]) -> None:
        self.records.append(dict(event))
        print(f"broker append: {event['event_id']} (total copias={len(self.records)})")


@dataclass
class ConsumerDB:
    projections: dict[str, int] = field(default_factory=dict)
    inbox: set[str] = field(default_factory=set)

    def apply_with_inbox(self, event: dict[str, Any]) -> None:
        """Representa inbox + efecto en una transacción local."""
        event_id = event["event_id"]
        if event_id in self.inbox:
            print(f"consumer deduplica {event_id}: ya procesado")
            return
        order_id = event["aggregate_id"]
        self.projections[order_id] = self.projections.get(order_id, 0) + 1
        self.inbox.add(event_id)
        print(f"consumer TX: proyección[{order_id}]={self.projections[order_id]} + inbox")


def relay_once(db: LocalDB, broker: Broker, event_id: str, lose_ack: bool) -> None:
    event = db.outbox[event_id]
    broker.publish(event)
    if lose_ack:
        print("ACK del broker perdido: relay no marca published y volverá a publicar")
        return
    event["published"] = True
    print("relay marca published=True")


@dataclass
class Saga:
    saga_id: str
    state: str = "NEW"
    stock_reserved: bool = False
    paid: bool = False

    def reserve(self) -> None:
        if not self.stock_reserved:
            self.stock_reserved = True
        self.state = "STOCK_RESERVED"

    def pay(self) -> None:
        if not self.paid:
            self.paid = True
        self.state = "PAYMENT_AUTHORIZED"

    def transfer(self, fail: bool = False) -> bool:
        if fail:
            self.state = "COMPENSATING"
            return False
        self.state = "COMPLETED"
        return True

    def compensate(self) -> None:
        # Idempotente: repetir deja el mismo estado lógico.
        self.paid = False       # representa refund confirmado
        self.stock_reserved = False
        self.state = "COMPENSATED"


def demo_outbox() -> None:
    print("\n=== OUTBOX -> RELAY -> REDelivery -> INBOX ===")
    db, broker, consumer = LocalDB(), Broker(), ConsumerDB()
    db.create_order_and_event("O-17", "evt-O-17-created")

    # Primera publicación llega al broker, pero el relay pierde el ACK.
    relay_once(db, broker, "evt-O-17-created", lose_ack=True)
    # Reinicio/retry del relay: el mismo event_id se publica otra vez.
    relay_once(db, broker, "evt-O-17-created", lose_ack=False)

    print("\nconsumir ambas copias:")
    for record in broker.records:
        consumer.apply_with_inbox(record)
    print(f"resultado final: {consumer.projections}")


def demo_saga() -> None:
    print("\n=== SAGA DURABLE SIMPLIFICADA ===")
    s = Saga("S-17")
    print(s)
    s.reserve(); print(s)
    s.pay(); print(s)
    if not s.transfer(fail=True):
        print("transferencia falla; iniciar compensaciones")
        s.compensate(); print(s)
        print("repetir compensación:")
        s.compensate(); print(s)


if __name__ == "__main__":
    demo_outbox()
    demo_saga()
