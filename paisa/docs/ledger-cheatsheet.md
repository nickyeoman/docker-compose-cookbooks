# Ledger Cheatsheet

Quick reference for the plain-text [ledger](https://ledger-cli.org/)
format that Paisa reads. Full docs: [ledger manual](https://ledger-cli.org/doc/ledger3.html)
and [paisa.fyi](https://paisa.fyi/).

## Transaction basics

```ledger
2026/01/05 Payee | Description
    Expenses:Fuel                           850.00 CAD
    Assets:GST:InputTaxCredits               42.50 CAD
    Liabilities:CreditCard
```

-   First line: date, optional status, payee/description.
-   Postings are indented (at least 2 spaces or a tab).
-   Separate account and amount with **2+ spaces** or a tab.
-   Every transaction must balance to zero. One posting may omit its
    amount; ledger fills in whatever balances it.
-   Positive = debit, negative = credit. See [Account types](#account-types)
    for each root's normal balance.

## Status marks

```ledger
2026/01/05 * Cleared transaction
2026/01/06 ! Pending transaction
```

## Comments

```ledger
; whole-line comment
2026/01/05 Fuel station  ; note on the transaction
    Expenses:Fuel        850.00 CAD  ; note on a posting
    Liabilities:CreditCard
```

## Account types

| Root          | Normal balance | Example                      |
| ------------- | -------------- | ---------------------------- |
| `Assets`      | Positive       | `Assets:Bank:Chequing`       |
| `Liabilities` | Negative       | `Liabilities:CreditCard`     |
| `Equity`      | Negative       | `Equity:OpeningBalances`     |
| `Income`      | Negative       | `Income:Demolition`          |
| `Expenses`    | Positive       | `Expenses:Fuel`              |

Use `:` for sub-accounts. Paisa groups its reports by these roots.

## Declarations

```ledger
commodity CAD
    format 1,000.00 CAD

account Assets:Bank:Chequing
account Expenses:Fuel
```

With `strict: "yes"` in `paisa.yaml`, every account and commodity must be
declared before it is used.

## Includes

```ledger
include accounts.ledger
include 2026.ledger
```

Ledger itself accepts any path, but Paisa only reads included files in
the same folder as the main journal or a subfolder.

## Budgets (periodic transactions)

```ledger
~ Monthly
    Expenses:Fuel        3,000.00 CAD
    Expenses:Disposal    4,000.00 CAD
    Assets:Bank:Chequing
```

Paisa reads `~ Monthly` entries as the monthly budget.

## Common Canadian business patterns

Sale with GST 5% + BC PST 7%:

```ledger
2026/01/30 Invoice 1001 | Main St demolition
    Assets:AccountsReceivable            31,360.00 CAD
    Income:Demolition                   -28,000.00 CAD
    Liabilities:GST:Collected            -1,400.00 CAD
    Liabilities:PST:Collected            -1,960.00 CAD
```

Customer pays the invoice:

```ledger
2026/02/10 Customer | Payment on invoice 1001
    Assets:Bank:Chequing                 31,360.00 CAD
    Assets:AccountsReceivable
```

Purchase with a GST input tax credit:

```ledger
2026/01/20 Landfill | Tipping fees
    Expenses:Disposal                     3,200.00 CAD
    Assets:GST:InputTaxCredits              160.00 CAD
    Assets:Bank:Chequing
```

Payroll, with source deductions owed to CRA:

```ledger
2026/01/31 Payroll | January wages
    Expenses:Wages                       18,000.00 CAD
    Liabilities:Payroll:CRA              -4,500.00 CAD
    Assets:Bank:Chequing
```

Loan payment split into principal and interest:

```ledger
2026/01/31 Lender | Equipment loan
    Liabilities:Loan:Equipment            2,800.00 CAD
    Expenses:Interest                       650.00 CAD
    Assets:Bank:Chequing
```

Transfer between your own accounts:

```ledger
2026/02/28 Transfer | To savings
    Assets:Bank:Savings                   2,000.00 CAD
    Assets:Bank:Chequing
```

Opening balances:

```ledger
2026/01/01 Opening balances
    Assets:Bank:Chequing                 45,000.00 CAD
    Liabilities:Loan:Equipment         -120,000.00 CAD
    Equity:OpeningBalances
```

Year-end closing entry (net loss moved to retained earnings):

```ledger
2025/12/31 * Year end | Close 2025 income and expenses  ; :closing:
    Expenses:Incorporation                   -350.00 CAD
    Expenses:ProfessionalFees              -1,500.00 CAD
    Expenses:Interest                        -670.00 CAD
    Equity:RetainedEarnings                 2,520.00 CAD
```

Reverse each Income and Expenses balance for the year and post the
difference to `Equity:RetainedEarnings`. A profit shows as a negative
(credit) to retained earnings, and a loss as a positive (debit).

## CLI commands (inside the container)

Run them with `docker compose exec paisa sh` (or open the container console in Dockhand), then `cd /root/Documents/paisa`:

| Command                                   | Shows                          |
| ----------------------------------------- | ------------------------------ |
| `ledger -f main.ledger bal`               | Balances for every account     |
| `ledger -f main.ledger bal Expenses`      | Expense totals                 |
| `ledger -f main.ledger reg Assets:Bank`   | Running register for the bank  |
| `ledger -f main.ledger bal -p "2026/01"`  | January 2026 balances          |
| `ledger -f main.ledger bal -M Expenses`   | Expenses by month              |
| `ledger -f main.ledger --strict bal`      | Warns about undeclared accounts|
| `ledger -f main.ledger accounts`          | List of accounts               |
| `ledger -f main.ledger payees`            | List of payees                 |

After editing files by hand, click **Sync** in Paisa so it rebuilds the
database from the journal.
