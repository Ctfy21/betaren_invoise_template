# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Automated commercial proposal (КП) generator for "Щёлково Агрохим" (Betaren) — winter wheat division. A salesperson fills in an XLSX template (5 fields), and the system calculates volumes, selects variety data and arguments, then generates a branded PDF via Typst.

## Workflow

```
1. python create_template.py        → input_template.xlsx (one-time)
2. Salesperson fills input_template.xlsx
3. python generate.py input.xlsx     → data.json → PDF
```

## Build Commands

Generate input template (run once):
```
python create_template.py
```

Generate KP from filled XLSX:
```
python generate.py filled_input.xlsx
python generate.py filled_input.xlsx -o custom_name.pdf
```

Compile Typst manually (after data.json exists):
```
typst compile main.typ
```

## Architecture

**Pipeline: XLSX → Python → JSON → Typst → PDF**

- **create_template.py** — Generates `input_template.xlsx` with 8 fields (client name, region, area, variety, pain point, contact, manager) and dropdown validation from `varieties.json`.
- **generate.py** — Main processing script. Reads filled XLSX, loads variety + technology databases, calculates volumes (area × rates, seed tonnage × seed-treatment rates), selects pain-based arguments, writes `data.json`, and invokes `typst compile`.
- **main.typ** — 3–4 page Typst template:
  - Page 1: Branded cover (year, logo, variety name, client info)
  - Page 2: Variety card (yield stats, advantages, pain-based argument block)
  - Page 3: Technology card table with per-product cost calculation + grand total
  - Page 4: Next step CTA + manager signature

**Data files:**

- **varieties.json** — 7 winter wheat varieties with registry info, yield data, disease resistance, and pain-specific arguments (засуха/болезни/качество).
- **technology.json** — Technology card: 4 seasons, 8 numbered treatments, ~25 products with application rates, units, categories, and prices. Includes seeding rate (220 kg/ha).
- **data.json** — Generated intermediate file consumed by Typst. Not edited manually.

**Image assets** (must be placed in project root):
`logo.png`, `decor-header.png`, `decor-body.png`, `team-photo.png`. Placeholder PNGs included for development.

## Key Conventions

- Language is Russian throughout; Typst text lang is `"ru"`.
- Volume calculation logic: `rate_basis: "seed"` → rate × seed_tonnes; otherwise → rate × area_ha.
- `fmt()` in Typst formats integers with space-separated thousands (Russian locale).
- Pain point must be one of: Засуха, Болезни, Качество.
- Prices in `technology.json` are per-unit (per liter, per kg). The Python script computes total cost = volume × price.
