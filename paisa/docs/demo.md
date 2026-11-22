# Using the Demo Data

The `demo/` folder is a complete ledger git repo for a fictional
British Columbia business, **Demolition Company Ltd.** Use it to explore
Paisa before entering your own books. All figures are made up.

## What's in it

| File              | Purpose                                                    |
| ----------------- | ---------------------------------------------------------- |
| `paisa.yaml`      | Paisa config: CAD, BC time zone, strict accounts, goals    |
| `main.ledger`     | Entry point; includes the other files                      |
| `accounts.ledger` | Chart of accounts and the CAD commodity                    |
| `budget.ledger`   | Monthly budget (periodic transaction)                      |
| `2025.ledger`     | Incorporation, share issue, equipment purchase (Dec 2025)  |
| `2026.ledger`     | January and February 2026 transactions                     |
| `sheets/`         | Paisa sheet with 2025 and 2026 tax estimates               |
| `.gitignore`      | Keeps `paisa.db` out of git if both paths share a folder   |

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

December 2025 covers incorporation and legal fees, the share issue, a
$120,000 equipment loan, machinery and vehicle purchases (BC PST added to
the asset cost, GST claimed as input tax credits), a savings transfer, a
petty cash float, and the first loan payment.

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

## Where the files go

| Data                          | Host path                    | In git? |
| ----------------------------- | ---------------------------- | ------- |
| `paisa.yaml`, `*.ledger`      | `${PAISA_LEDGER_PATH:-/data/paisa}` | Yes |
| `paisa.db` (SQLite)           | `${VOL_PATH:-/data}/paisa`     | No, backed up by restic |

Out of the box both are `/data/paisa`.

## Load the demo

1. Clone this repo somewhere on the Docker host, e.g.:
   ```bash
   cd /data/paisa
   git clone https://github.com/nickyeoman/docker-compose-cookbooks.git
   ```
2. In Dockhand, set the stack's environment variable to the demo folder:
   ```env
   PAISA_LEDGER_PATH=/data/paisa/docker-compose-cookbooks/paisa/demo
   ```
   The path is used as-is, so the ledger comes straight from the clone.
   The database stays in `${VOL_PATH:-/data}/paisa` (from `db_path` in
   `demo/paisa.yaml`).
3. Redeploy the stack and open http://localhost:7500 (or the host's
   address or proxy hostname if you're not on the Docker host).

## Switch back to your own books

Set `PAISA_LEDGER_PATH` back to your books (default `/data/paisa`) and
redeploy. Paisa rebuilds `paisa.db` from the ledger files, so the demo
data in it is replaced on the next sync.

## Start your own books

-   **New business:** copy `template/` instead of `demo/`. It has a
    chart of accounts for a small BC corporation, `strict: "yes"`, a
    sample budget, and a year file with commented examples. Fill in the
    `TODO`s in `paisa.yaml`, `main.ledger`, and `accounts.ledger`.
-   **Blank slate:** copy `config/`. It holds the same defaults with an
    empty journal, `strict: "no"`, and no accounts.
