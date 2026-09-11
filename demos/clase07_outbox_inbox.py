#!/usr/bin/env python3
"""Outbox, ACK perdido, republicación e inbox idempotente."""
from __future__ import annotations

from dataclasses import dataclass, field


@dataclass
class ProducerDB:
    orders: dict[str, str] = field(default_factory=dict)
    outbox: dict[str, dict[str, str | bool]] = field(default_factory=dict)

    def confirm_order(self, order_id: str, event_id: str) -> None:
        # Modelo didáctico de una única transacción local.
        self.orders[order_id] = "CONFIRMED"
        self.outbox[event_id] = {
            "aggregate_id": order_id,
            "type": "OrderConfirmed",
            "published": False,
        }
        print("COMMIT local: pedido + evento pendiente")


@dataclass
class Broker:
    records: list[str] = field(default_factory=list)

    def publish(self, event_id: str) -> None:
        self.records.append(event_id)
        print(f"broker acepta {event_id}; copias en log={self.records.count(event_id)}")


@dataclass
class ConsumerDB:
    inbox: set[str] = field(default_factory=set)
    stock: int = 10

    def apply(self, event_id: str) -> None:
        # Modelo didáctico de transacción atómica inbox + efecto.
        if event_id in self.inbox:
            print(f"consumer deduplica {event_id}; stock sigue {self.stock}")
            return
        self.inbox.add(event_id)
        self.stock -= 1
        print(f"COMMIT consumer: inbox + stock; stock={self.stock}")


producer = ProducerDB()
broker = Broker()
consumer = ConsumerDB()

producer.confirm_order("9F2A", "evt-9F2A-1")

print("\nRelay publica, pero pierde el ACK:")
broker.publish("evt-9F2A-1")
print("ACK perdido; el relay no puede distinguir éxito de ausencia")

print("\nRelay reintenta:")
broker.publish("evt-9F2A-1")
producer.outbox["evt-9F2A-1"]["published"] = True

print("\nConsumer recibe ambas copias:")
for record in broker.records:
    consumer.apply(record)

print("\nResultado:")
print(f"  publicaciones físicas: {len(broker.records)}")
print(f"  efectos lógicos: {10 - consumer.stock}")
