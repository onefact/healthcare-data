---
toc: false
---

<style>

.hero {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: var(--sans-serif);
  margin: 4rem 0 8rem;
  text-wrap: balance;
  text-align: center;
}

.hero h1 {
  margin: 2rem 0;
  max-width: none;
  font-size: 14vw;
  font-weight: 900;
  line-height: 1;
  background: linear-gradient(30deg, var(--theme-foreground-focus), currentColor);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero h2 {
  margin: 0;
  max-width: 34em;
  font-size: 20px;
  font-style: initial;
  font-weight: 500;
  line-height: 1.5;
  color: var(--theme-foreground-muted);
}

@media (min-width: 640px) {
  .hero h1 {
    font-size: 90px;
  }
}

</style>

<div class="hero">
  <h1>Synthetic Healthcare Data</h1>
  <h2>Welcome to nonprofit research into healthcare thanks to the Agency for Healthcare Research and Quality in the United States' Department of Health and Human Services!</h2>
  <a href="https://www.ahrq.gov/sites/default/files/wysiwyg/data/SyH-DR-Codebook.pdf">Learn more about variables in the data<span style="display: inline-block; margin-left: 0.25rem;">↗︎</span></a>
</div>


---

```js
import {DuckDBClient} from "npm:@observablehq/duckdb";
const db = DuckDBClient.of({data: FileAttachment("data/insurance_plan_payment_histogram.parquet")});
```


```js
const orderInsurance = [
  'Commercial',
  'Medicaid',
  'Medicare',
];
```

```js
const paymentData = await db.query(`
  SELECT Payment, count, Insurance FROM data
`);
```

```js
function paymentChart(paymentData, width) {
  // Create a histogram with a logarithmic base.
  return Plot.plot({
    width,
    marginLeft: 60,
    x: { type: "log", domain: [1, 1000000] }, // Set the domain of the x-axis to be fixed between 1 and 1,000,000
    y: { axis: null }, // Hide the y-axis
    color: { legend: "swatches", columns: 1, domain: orderInsurance },
    marks: [
      Plot.rectY(
        paymentData,
        Plot.binX(
          { y: "sum" },
          {
            x: "Payment",
            y: "count",
            fill: "Insurance",
            order: orderInsurance,
            thresholds: d3
              .ticks(Math.log10(1), Math.log10(1000000), 40)
              .map((d) => +(10 ** d).toPrecision(3)),
            tip: true,
          }
        )
      ),
    ],
  });
}
```

<div class="card"> <h2>Payment distributions vary by insurance type</h2> <h3>The amount paid for the inpatient health care costs of 1.2 million people in 2016 representing $8.5 billion in health care costs. This dataset is created by the Agency for Healthcare Research and Quality and includes synthetic patient data categorized by insurance type.</h3> <h3> <code style="font-size: 90%;"><a href="https://github.com/onefact/synthetic-healthcare-data/blob/6dc81b75277f349d112bccc0a8db61d9b2240c4e/healthcare_data/models/figures/insurance_plan_payment_histogram.sql">Code for data transform</a></code></h3> ${resize((width) => paymentChart(paymentData, width))} </div>

---

## Next steps

We need ideas! Take a look at the source code at https://github.com/onefact/synthetic-healthcare-data and e mail us at hello@onefact.org if you want to volunteer on this. We will be looking at large language models and algorithmic fairness metrics in health care settings next. 
<!-- 
<div class="grid grid-cols-4">
  <div class="card">
    Chart your own data using <a href="https://observablehq.com/framework/lib/plot"><code>Plot</code></a> and <a href="https://observablehq.com/framework/javascript/files"><code>FileAttachment</code></a>. Make it responsive using <a href="https://observablehq.com/framework/javascript/display#responsive-display"><code>resize</code></a>.
  </div>
  <div class="card">
    Create a <a href="https://observablehq.com/framework/routing">new page</a> by adding a Markdown file (<code>whatever.md</code>) to the <code>docs</code> folder.
  </div>
  <div class="card">
    Add a drop-down menu using <a href="https://observablehq.com/framework/javascript/inputs"><code>Inputs.select</code></a> and use it to filter the data shown in a chart.
  </div>
  <div class="card">
    Write a <a href="https://observablehq.com/framework/loaders">data loader</a> that queries a local database or API, generating a data snapshot on build.
  </div>
  <div class="card">
    Import a <a href="https://observablehq.com/framework/javascript/imports">recommended library</a> from npm, such as <a href="https://observablehq.com/framework/lib/leaflet">Leaflet</a>, <a href="https://observablehq.com/framework/lib/dot">GraphViz</a>, <a href="https://observablehq.com/framework/lib/tex">TeX</a>, or <a href="https://observablehq.com/framework/lib/duckdb">DuckDB</a>.
  </div>
  <div class="card">
    Ask for help, or share your work or ideas, on the <a href="https://talk.observablehq.com/">Observable forum</a>.
  </div>
  <div class="card">
    Visit <a href="https://github.com/observablehq/framework">Framework on GitHub</a> and give us a star. Or file an issue if you’ve found a bug!
  </div>
</div> -->
