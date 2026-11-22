# Using the Demo Data

The `demo/` folder is a complete ledger git repo for a fictional
British Columbia business, **Demolition Company Ltd.** Use it to explore
Paisa before entering your own books. All figures are made up.

## What's in it

| File              | Purpose                                                    |
| ----------------- | ---------------------------------------------------------- |
| `paisa.yaml`      | Paisa config: CAD, BC time zone, strict accounts, goals    |
| `main.ledger`     | Entry point; includes the other files                      |
| `accounts.ledger` | Chart of accounts and the CAD and BTC commodities          |
| `budget.ledger`   | Monthly budget (periodic transaction)                      |
| `2025.ledger`     | Incorporation, share issue, equipment purchase (Dec 2025)  |
| `2026.ledger`     | January and February 2026 transactions                     |
| `sheets/`         | Paisa sheet with 2025 and 2026 tax estimates               |
| `.gitignore`      | Keeps `paisa.db` out of git                                |

## The company

-   Incorporated in British Columbia on **December 1, 2025**
-   Fiscal year end: **December 31**
-   100 common shares issued at $2,500 each ($250,000 share capital)

| Shareholder                | Class               | Shares | Paid (CAD) |
| -------------------------- | ------------------- | -----: | ---------: |
| CEO                        | A (voting)          |     26 |  65,000.00 |
| CAO                        | A (voting)          |     25 |  62,500.00 |
| CFO                        | A (voting)          |     10 |  25,000.00 |
| Secretary                  | A (voting)          |      5 |  12,500.00 |
| Investor01 to Investor04   | B (non-voting)      |      4 |  10,000.00 |
| Investor05 to Investor10   | B (non-voting)      |      3 |   7,500.00 |
| **Total**                  |                     |    100 | 250,000.00 |

Investor rows are per investor (four holders at 4 shares, six at 3).

The four officers hold 66 voting shares. The CEO's 26 is the largest
single block, but no officer has a majority alone. The ten family and
friends investors hold 34 non-voting Class B shares: they share in the
equity but have no vote. Each holder has an account under
`Equity:ShareCapital:ClassA` or `ClassB`, and each posting carries a
`Shares:` tag with the share count.

## Banks and investments

| Account                          | Used for                                          |
| -------------------------------- | ------------------------------------------------- |
| `Assets:Bank:BMO:Chequing`       | Main operating account: deposits, bills, transfers|
| `Assets:Bank:RBC:Payroll`        | Pays the crew; funded from BMO before each payroll|
| `Assets:Bank:Scotiabank:Savings` | Excavator replacement fund (savings goal)         |
| `Assets:Bank:CIBC:TaxReserve`    | Cash held back for income tax, GST and PST        |
| `Assets:Investments:GIC:CIBC`    | $10,000 1-year GIC at 4.00%, matures 2027/01/15   |
| `Assets:Crypto:Wallet`           | 0.05 BTC bought at $135,000 per BTC               |

GIC interest is accrued monthly to `Income:Interest` and added to the GIC
balance. Bitcoin is held in its own `BTC` commodity; `P` price lines in
`2026.ledger` set its market value, so Paisa shows an unrealized loss
when the price drops to $128,000 at the end of February.

December 2025 covers incorporation and legal fees, the share issue, a
$120,000 equipment loan, machinery and vehicle purchases (BC PST added to
the asset cost, GST claimed as input tax credits), office equipment
(desks, chairs, laptops, a desktop and a printer, $8,453) and hand tools
($2,782) recorded as assets, a savings transfer, a
payroll account float, a petty cash float, and the first loan payment.

The crew also did three small jobs that month:

| Invoice | Job                           | Before tax | With GST + PST | Paid          |
| ------- | ----------------------------- | ---------: | -------------: | ------------- |
| 1001    | Backyard shed removal         |   2,500.00 |       2,800.00 | Dec 16, 2025  |
| 1002    | Kitchen tear-out, Oak Ave     |   4,800.00 |       5,376.00 | Jan 8, 2026   |
| 1003    | Detached garage demolition    |   7,500.00 |       8,400.00 | Dec 30, 2025  |

Plus scrap steel sales, landfill fees, fuel on the credit card, December
wages, and the WorkSafeBC premium. Invoice 1002 is still owed at year end,
and $840 of fuel is still on the credit card; both are settled in 2026.

## Year end, December 31, 2025

The first fiscal year is one month long. `2025.ledger` ends with two
entries dated December 31:

1. **Tax accrual:** corporate income tax at the 11% small business rate
   (9% federal + 2% BC) on 3,890.00 of profit = 427.90, owed to CRA.
2. **Closing entry**, tagged `:closing:`: moves every 2025 income and
   expense balance into `Equity:RetainedEarnings`.

| 2025                                   |  CAD       |
| -------------------------------------- | ---------: |
| Demolition income                      |  14,800.00 |
| Scrap income                           |     650.00 |
| **Total income**                       | **15,450.00** |
| Wages                                  |   6,000.00 |
| Disposal                               |   2,000.00 |
| Professional fees                      |   1,500.00 |
| Fuel                                   |     800.00 |
| Interest                               |     670.00 |
| Incorporation                          |     350.00 |
| WorkSafeBC                             |     240.00 |
| **Total expenses**                     | **11,560.00** |
| Net income before tax                  |   3,890.00 |
| Corporate income tax (11%)             |     427.90 |
| **Net income to retained earnings**    | **3,462.10** |

The T2 return and the tax balance are due June 30, 2026 (six months after
year end). The small business rates are a simplification for the demo;
confirm current rates with an accountant.

Accountants new to Paisa: read
[Paisa for Accountants](paisa-for-accountants.md#closing-entries) before
relying on Paisa's December 2025 reports. The closing entry makes them show
zero net income for that month.

## Tax estimates sheet

`sheets/tax-estimates.paisa` (in Paisa: **More → Sheets**) uses the
ledger to work out profit, the 11% small business tax, net GST, and PST
for fiscal 2025 and 2026 to date, then totals the cash to set aside. It
skips the closing entry so the 2025 figures aren't zero. The expected
result is in a comment on each line, so you can check it against the
ledger.

## 2026 activity

The 2026 books cover demolition invoices with GST 5% and
BC PST 7%, scrap metal sales (GST only), expenses with GST input tax
credits, payroll and CRA remittances, WorkSafeBC premiums, an equipment
loan, a credit card, and a savings transfer toward an excavator fund.
Each month the office pays for business internet (GST + PST), water
delivery and cooler rental (the water itself is zero-rated), and a
cleaning service that wipes down the computers and vacuums the floors
(GST only). Office supplies such as paper are expensed, not added to
`Assets:Equipment:Office`.
Day-to-day purchases go on the company Visa (statement closes on the
15th): fuel, safety gear, saw blades and drill bits, the accounting
software subscription, job-site parking, and toner and paper. The
February 16 payment clears everything through the February 15
statement; $1,246.00 charged after that is still owing at the end of
February, so the Credit Cards page shows an open balance.
It also buys the GIC and the bitcoin, funds each payroll from BMO to RBC,
and moves the tax estimate from the sheet into the CIBC tax reserve.

## Where the files go

Everything lives in one folder, `${VOL_PATH:-/data}/paisa`: the
`paisa.yaml` and `*.ledger` files (in git) and `paisa.db` (a cache,
ignored by `.gitignore`).

## Load the demo

1. From the root of this repo, copy the demo into its own folder named
   `paisa`, keeping your real books separate:
   ```bash
   mkdir -p /data/demo
   cp -r paisa/demo /data/demo/paisa
   ```
2. In Dockhand, edit the stack's environment variable:
   ```env
   VOL_PATH=/data/demo
   ```
   The compose file appends `/paisa`, so Paisa reads `/data/demo/paisa`
   and writes `paisa.db` there.
3. Redeploy the stack and open http://localhost:7500 (or the host's
   address or proxy hostname if you're not on the Docker host).

## Switch back to your own books

Set `VOL_PATH` back to your value (default `/data`) and redeploy. The
demo folder `/data/demo` can be deleted any time.

## Start your own books

-   **From a template:** copy one of the `templates/` folders instead of
    `demo/`: `personal/`, `household/`, `business/` (sole proprietor), or
    `corporation/` (small BC corporation). Each has a chart of accounts,
    `strict: "yes"`, a sample budget, and a year file with commented
    examples. Fill in the `TODO`s in `paisa.yaml`, `main.ledger`, and
    `accounts.ledger`.
-   **Blank slate:** copy `config/`. It holds the same defaults with an
    empty journal, `strict: "no"`, and no accounts.
