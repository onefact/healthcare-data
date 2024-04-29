# Synthetic Healthcare Data

## README from Observable Framework default documentation

This is an [Observable Framework](https://observablehq.com/framework) project. To start the local preview server, run:

```
yarn dev
```

Then visit <http://localhost:3000> to preview your project.

For more, see <https://observablehq.com/framework/getting-started>.

## Project structure

A typical Framework project looks like this:

```ini
.
├─ docs
│  ├─ components
│  │  └─ timeline.js           # an importable module
│  ├─ data
│  │  ├─ launches.csv.js       # a data loader
│  │  └─ events.json           # a static data file
│  ├─ example-dashboard.md     # a page
│  ├─ example-report.md        # another page
│  └─ index.md                 # the home page
├─ .gitignore
├─ observablehq.config.js      # the project config file
├─ package.json
└─ README.md
```

**`docs`** - This is the “source root” — where your source files live. Pages go here. Each page is a Markdown file. Observable Framework uses [file-based routing](https://observablehq.com/framework/routing), which means that the name of the file controls where the page is served. You can create as many pages as you like. Use folders to organize your pages.

**`docs/index.md`** - This is the home page for your site. You can have as many additional pages as you’d like, but you should always have a home page, too.

**`docs/data`** - You can put [data loaders](https://observablehq.com/framework/loaders) or static data files anywhere in your source root, but we recommend putting them here.

**`docs/components`** - You can put shared [JavaScript modules](https://observablehq.com/framework/javascript/imports) anywhere in your source root, but we recommend putting them here. This helps you pull code out of Markdown files and into JavaScript modules, making it easier to reuse code across pages, write tests and run linters, and even share code with vanilla web applications.

**`observablehq.config.js`** - This is the [project configuration](https://observablehq.com/framework/config) file, such as the pages and sections in the sidebar navigation, and the project’s title.

## Command reference

| Command           | Description                                              |
| ----------------- | -------------------------------------------------------- |
| `yarn install`            | Install or reinstall dependencies                        |
| `yarn dev`        | Start local preview server                               |
| `yarn build`      | Build your static site, generating `./dist`              |
| `yarn deploy`     | Deploy your project to Observable                        |
| `yarn clean`      | Clear the local data loader cache                        |
| `yarn observable` | Run commands like `observable help`                      |


## README for Data Build Tool (dbt)

[On a new computer]
Clone the repo, then run:
Set up environment:
```bash
python3 -m venv .venv 
```

Activate the environment:
```bash
source .venv/bin/activate
```

Install dependencies:
```bash
pip install -r requirements.txt
```

## Updating the environment

Install pip-tools:
```bash
pip install pip-tools
```

Compile dependencies:
```bash
pip-compile 
```

Initializing a dbt project:
```bash
dbt init data_processing
```

## Building the datasets

1. Generate the synthetic healthcare data schemas using the data dictionary:

```bash
cd data_processing
python scripts/generate_syh_dr_data_models.py ~/data/syh_dr https://www.ahrq.gov/sites/default/files/wysiwyg/data/SyH-DR-Codebook.pdf
```

2. Generate the synthetic healthcare data (takes ~2.5 minutes, with 8 threads on a Macbook):

```bash
dbt run --threads 8
```

3. Verify that you can query the data on the command line:

```bash
duckdb -c "SELECT * FROM '~/data/syh_dr/syhdr_commercial_inpatient_2016.parquet'"
```

This should show the data:

```
┌──────────────────────┬──────────────────────┬───┬──────────────────────┬──────────────────────┬──────────────────────┐
│ CAST(PERSON_ID AS …  │ CAST(PERSON_WGHT A…  │ … │ CAST(CPT_PRCDR_CD_…  │ CAST(replace(repla…  │ CAST(replace(repla…  │
│        uint64        │    decimal(18,3)     │   │       varchar        │        float         │        float         │
├──────────────────────┼──────────────────────┼───┼──────────────────────┼──────────────────────┼──────────────────────┤
...
├──────────────────────┴──────────────────────┴───┴──────────────────────┴──────────────────────┴──────────────────────┤
│ 386816 rows (40 shown)                                                                         101 columns (5 shown) │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## To build a specific data model

Use `--select` in dbt:

```bash
dbt run --select "syhdr_medicare_outpatient_2016"
```

## To build a specific figure for visualization with Observable Framework

Use `--select` in dbt to select models, e.g. in order to build all histograms:

```bash
dbt run --select "*histogram*"
```

Check the total payment amount:

```bash
❯ duckdb -c "SELECT SUM(Payment * Count) FROM '/Users/me/data/syh_dr/insurance_plan_payment_histogram.parquet'"
┌────────────────────────┐
│ sum((Payment * Count)) │
│         double         │
├────────────────────────┤
│       8570849798.39355 │
└────────────────────────┘
```

# Contributors

[@wesleycheung0](https://github.com/wesleycheung0), [@sumanthkaja](https://github.com/sumanthkaja), [@jaanli](https://github.com/jaanli) (reach out if you also want to volunteer on this and have worked with dbt, duckdb, healthcare data, or Observable Framework! We will be working with large language models next)

# Copyright
(c) 2024 All Bets LLC, a wholly-owned subsidiary of One Fact Foundation (a 501(c)(3) nonprofit). This legal structure is required by the United States' Internal Revenue Service to allow non-profit organizations to engage in the creation of open source software, which outside of non-profits is typically done by for-profit companies and requires significant taxation.

# Contact

File an issue here or email `hello@onefact.org`. 
