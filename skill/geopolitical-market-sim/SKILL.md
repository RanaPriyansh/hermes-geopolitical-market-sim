---
name: geopolitical-market-sim
description: Track geopolitical topics, select relevant open Polymarket contracts near deadline, generate MiroFish seed packets from WorldOSINT data, and optionally run the MiroFish simulation pipeline. Use this when the user wants recurring geopolitical prediction-market monitoring, topic tracking, or a local automation path from news + markets into MiroFish.
---

# Geopolitical Market Sim

Use this skill for the local WorldOSINT -> Polymarket -> MiroFish workflow.

Helper script path:
`~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py`

## What it does

- stores tracked geopolitical topics in `~/.hermes/data/geopolitical-market-sim/topics.json`
- fetches topic-relevant RSS/news from local WorldOSINT headless modules
- searches open Polymarket markets, prefers near-deadline contracts, and pulls top-of-book pricing
- writes a MiroFish-ready seed packet and raw snapshot under `~/.hermes/data/geopolitical-market-sim/runs/...`
- optionally drives the full MiroFish API pipeline with moderate defaults

## Default operating mode

Use moderate settings unless the user asks otherwise:
- `platform=parallel`
- `max_rounds=24`
- `use_llm_for_profiles=false`
- `enable_graph_memory_update=false`
- do not generate the MiroFish report unless the user asks

## First checks

Run health before first use or when failures look environmental:

```bash
python3 ~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py health
```

If `MiroFish` is down, do not claim the simulation ran. If `WorldOSINT` is down, do not claim the packet is current.

## Track a topic

```bash
python3 ~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py \
  track-topic \
  --topic-id iran-conflict \
  --topic "Iran conflict and nuclear diplomacy" \
  --market-query "Iran nuclear deal" \
  --keyword iran --keyword israel --keyword hormuz --keyword nuclear --keyword enrichment --keyword iaea \
  --region-code IR --region-code IL --region-code SA --region-code US \
  --theater-region "Persian Gulf" \
  --theater-region "Arabian Sea" \
  --theater-region "Red Sea" \
  --theater-region "Eastern Mediterranean Sea"
```

## Run ad hoc without saving

```bash
python3 ~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py \
  run-topic \
  --topic "Iran conflict and nuclear diplomacy" \
  --market-query "Iran nuclear deal" \
  --keyword iran --keyword israel --keyword hormuz --keyword nuclear --keyword enrichment --keyword iaea \
  --simulate
```

## Run a tracked topic

Seed packet only:

```bash
python3 ~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py \
  run-tracked iran-conflict
```

Seed packet plus MiroFish simulation:

```bash
python3 ~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py \
  run-tracked iran-conflict \
  --simulate
```

## How to use the output

After a run:
- read `run_summary.md`
- if simulation ran, read `simulation_summary.md`
- use the selected primary contract question and description as the resolution anchor
- separate these clearly in your answer:
  - current market price / bid-ask
  - simulation-derived directional view
  - what evidence would change the call

Do not invent exact resolution criteria if the market description is vague. Say when the market page needs manual verification.

## Cron usage

Attach this skill to the Hermes cron job and make the prompt explicit. Keep the prompt self-contained.

Good cron prompt pattern:
- run the tracked topic by id
- if simulation succeeds, read the generated summaries
- return one final forecast for the primary market with concise reasons
- mention artifact paths in the final response

Example job intent:
- "Run the tracked topic `iran-conflict`. If the simulation succeeds, read the generated summaries and give a final YES/NO call for the primary market with 3-5 reasons. Mention the artifact paths."
