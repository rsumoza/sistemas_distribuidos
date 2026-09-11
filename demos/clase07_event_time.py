#!/usr/bin/env python3
"""Ventanas por event time y processing time, con evento tardío."""
from __future__ import annotations

from collections import defaultdict
from datetime import datetime, timedelta

EVENTS = [
    ("E1", "10:00:40", "10:00:43", 10),
    ("E2", "10:02:15", "10:02:16", 20),
    ("E3", "10:04:50", "10:07:10", 30),
]
FMT = "%H:%M:%S"
WINDOW_MINUTES = 5


def bucket(timestamp: str) -> str:
    value = datetime.strptime(timestamp, FMT)
    minute = (value.minute // WINDOW_MINUTES) * WINDOW_MINUTES
    start = value.replace(minute=minute, second=0)
    end = start + timedelta(minutes=WINDOW_MINUTES)
    return f"{start.strftime('%H:%M')}-{end.strftime('%H:%M')}"


def aggregate(time_index: int) -> dict[str, int]:
    result: dict[str, int] = defaultdict(int)
    for _event_id, event_time, arrival_time, value in EVENTS:
        chosen_time = (event_time, arrival_time)[time_index]
        result[bucket(chosen_time)] += value
    return dict(result)


def main() -> None:
    for label, time_index in [("event_time", 0), ("processing_time", 1)]:
        print(f"\n{label}")
        for window, total in sorted(aggregate(time_index).items()):
            print(f"  {window}: {total}")

    event_time = datetime.strptime("10:04:50", FMT)
    arrival_time = datetime.strptime("10:07:10", FMT)
    close_time = datetime.strptime("10:05:00", FMT)
    delay_from_event = arrival_time - event_time
    delay_after_close = arrival_time - close_time

    print("\nE3:")
    print(f"  demora desde el hecho: {delay_from_event}")
    print(f"  llegada posterior al cierre 10:05: {delay_after_close}")
    print("  con watermark de 2 min, la política debe decidir:")
    print("    descartar, enviar a late-events, reabrir o corregir una salida previa")


if __name__ == "__main__":
    main()
