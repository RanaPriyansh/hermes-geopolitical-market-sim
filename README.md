# Hermes Geopolitical Market Sim

Plug-and-play Hermes skill for geopolitical prediction workflows.

It combines:
- WorldOSINT headless modules for OSINT snapshots and RSS monitoring
- Polymarket Gamma/CLOB for open market selection and live yes bid/ask data
- MiroFish for graph-backed social simulation
- Hermes cron jobs for scheduled recurring forecasts

## What it does

The skill installs a local command workflow that can:
- track geopolitical topics with persistent topic configs
- fetch WorldOSINT headless data from 50+ monitoring modules
- select open Polymarket contracts near deadline with clear resolution wording
- generate MiroFish-ready seed packets and raw snapshots
- optionally run the full MiroFish simulation pipeline
- write run summaries Hermes can read back in normal chat or scheduled jobs

## Requirements

- Hermes Agent installed and working
- Python 3.10+
- WorldOSINT running locally or remotely
- MiroFish running locally or remotely if you want simulation execution

Recommended local defaults:
- `WORLDOSINT_BASE_URL=http://127.0.0.1:3000`
- `MIROFISH_BASE_URL=http://127.0.0.1:5001`
- `MIROFISH_ROOT=/absolute/path/to/MiroFish-main`

## Install

```bash
git clone git@github.com:nativ3ai/hermes-geopolitical-market-sim.git
cd hermes-geopolitical-market-sim
./install.sh
```

This copies the skill to:
- `~/.hermes/skills/research/geopolitical-market-sim`

It also installs the Python dependency used by the helper script.

## Health Check

```bash
python3 ~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py health
```

## Track a Topic

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

## Run a Topic

Seed packet only:

```bash
python3 ~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py run-tracked iran-conflict
```

Seed packet plus MiroFish simulation:

```bash
python3 ~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py run-tracked iran-conflict --simulate
```

## Use from Hermes Chat

```bash
hermes -s geopolitical-market-sim
```

Example prompts:
- `Run the tracked topic iran-conflict now and summarize the market.`
- `Read the latest Iran run_summary.md and simulation_summary.md and give the forecast.`
- `List my tracked geopolitical topics.`

## Schedule Daily Forecasts

```bash
hermes cron create 'every 1d' \
  "Using the terminal tool, run: python3 ~/.hermes/skills/research/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py run-tracked iran-conflict --simulate. Then read the generated run_summary.md and simulation_summary.md from the run directory and return a concise forecast for the primary market with the market question, current yes bid/ask, simulation directional call, 3-5 reasons, and artifact paths." \
  --skill geopolitical-market-sim \
  --name 'Iran Conflict Market Sim' \
  --deliver local
```

Make sure the Hermes gateway service is running so cron jobs fire.

## Configuration Notes

The helper script reads these environment variables if present:
- `WORLDOSINT_BASE_URL`
- `MIROFISH_BASE_URL`
- `MIROFISH_ROOT`
- `HERMES_HOME`

No API keys are stored in this repo. Configure provider keys through your normal Hermes or MiroFish environment.

## Repo Layout

- `skill/geopolitical-market-sim/SKILL.md`
- `skill/geopolitical-market-sim/agents/openai.yaml`
- `skill/geopolitical-market-sim/scripts/geopolitical_market_pipeline.py`
- `install.sh`
