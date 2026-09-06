#!/usr/bin/env python3
"""Ventanas por event time frente a processing time y late data."""
from datetime import datetime, timedelta
from collections import defaultdict

events = [
    ("E1", "10:00:40", "10:00:43", 10),
    ("E2", "10:02:15", "10:02:16", 20),
    ("E3", "10:04:50", "10:07:10", 30),
]
FMT = "%H:%M:%S"
WINDOW = 5

def bucket(ts: str) -> str:
    t = datetime.strptime(ts, FMT)
    minute = (t.minute // WINDOW) * WINDOW
    start = t.replace(minute=minute, second=0)
    end = start + timedelta(minutes=WINDOW)
    return f"{start.strftime('%H:%M')}-{end.strftime('%H:%M')}"

for mode, index in [("event_time", 1), ("processing_time", 2)]:
    agg = defaultdict(int)
    for _, event_t, arrival_t, value in events:
        agg[bucket((event_t, arrival_t)[index-1])] += value
    print(f"\n{mode}")
    for w, total in sorted(agg.items()):
        print(f"  {w}: {total}")

print("\nCon watermark de 2 min, E3 llega 2m10s después del cierre 10:05:")
print("  debe descartarse, enviarse a late-events o corregir una salida previa, según política.")
