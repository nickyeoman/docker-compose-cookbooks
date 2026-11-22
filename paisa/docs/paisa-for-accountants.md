# Paisa for Accountants

Notes for accountants and bookkeepers who know double-entry accounting
but haven't used Paisa or plain-text accounting before.

## How Paisa differs from accounting software

| Traditional software (QuickBooks, Sage)   | Paisa + ledger                                   |
| ----------------------------------------- | ------------------------------------------------ |
| Data lives in the program's database      | Data lives in plain `.ledger` text files in git  |
| Chart of accounts set up in the UI        | Accounts declared in `accounts.ledger`           |
| Entries made through forms                | Entries typed as text (or through Paisa's editor)|
| Period close locks the books              | Nothing is locked; git history is the audit trail|
| Closing entries required each year end    | Reports are built from any date range on demand  |

The database (`paisa.db`) is only a cache that Paisa rebuilds from the
ledger files. The `.ledger` files are the books of record.

## Sign convention

Ledger shows debits as positive and credits as negative. Income, equity,
and liability balances therefore show as negative numbers. This is
expected: `-15,450.00 CAD Income` means a 15,450.00 credit balance.

## Closing entries

**Paisa doesn't need closing entries.** It builds the income statement for
whatever period you pick by adding up the Income and Expenses postings in
that range. Income and expense accounts are never "reset"; a report for
2026 simply starts counting on January 1, 2026.

**What happens if you post one anyway.** The demo includes a closing
entry dated December 31, 2025 (tagged `:closing:`) so the books match what
an accountant expects at year end. Because it reverses every 2025 income
and expense balance on that date, Paisa's reports show:

-   December 2025 (and fiscal 2025) with **zero income, expenses, and net
    income**, since the reversal is posted to the same accounts on the
    same date
-   Correct balance sheet figures, including retained earnings

**To see the real 2025 figures,** exclude the closing entry with the
ledger CLI:

```bash
ledger -f main.ledger bal ^Income ^Expenses -p 2025 \
  --limit 'not has_tag("closing")'
```

**Choosing an approach:**

| Approach                                 | Paisa reports      | Retained earnings in the books     |
| ---------------------------------------- | ------------------ | ---------------------------------- |
| Post a closing entry (the demo)          | Fiscal year = zero | Recorded explicitly                |
| No closing entry                         | Correct            | Derived (equity + net income)      |
| Closing entry in a separate file         | Correct in Paisa   | Recorded; include file for filing  |

For the third option, put closing entries in a file such as
`closing.ledger` that `main.ledger` doesn't include. Paisa then reports
normally, and you can include it when preparing statements:
`ledger -f main.ledger -f closing.ledger bal`.

## Accruals and receivables

Accruals work as normal journal entries. For example, the demo accrues
2025 corporate income tax on December 31 and carries invoice 1002 as a
receivable into January. Paisa shows them in the period they're dated.

## Sales tax (GST/PST)

There's no tax engine. GST and PST are separate postings on each entry:

-   GST collected: `Liabilities:GST:Collected`
-   GST paid on purchases (input tax credits): `Assets:GST:InputTaxCredits`
-   BC PST collected: `Liabilities:PST:Collected`
-   BC PST paid on purchases isn't recoverable, so add it to the expense or
    asset cost

Net GST owing for a filing period:

```bash
ledger -f main.ledger bal GST -p "2025/12/01 to 2026/01/01"
```

## Useful reports for year-end work

| Report                       | Command                                                         |
| ---------------------------- | --------------------------------------------------------------- |
| Trial balance at year end    | `ledger -f main.ledger bal -e 2026/01/01`                       |
| Income statement for 2025    | `ledger -f main.ledger bal ^Income ^Expenses -p 2025 --limit 'not has_tag("closing")'` |
| Balance sheet at year end    | `ledger -f main.ledger bal ^Assets ^Liabilities ^Equity -e 2026/01/01` |
| General ledger for an account| `ledger -f main.ledger reg Assets:Bank:Chequing`                |
| Check for undeclared accounts| `ledger -f main.ledger --strict --pedantic bal`                 |

`-e` is an exclusive end date: `-e 2026/01/01` means "up to and including
December 31, 2025". If you skip closing entries, the trial balance shows
the year's Income and Expenses balances, and the balance sheet above only
balances once net income is added to equity (it isn't in
`Equity:RetainedEarnings` yet).

## Audit trail

Every change to the books is a git commit with an author, date, and diff.
To see who changed what:

```bash
git log -p -- 2025.ledger
```

Paisa doesn't lock periods. If you need closed periods protected, use git
practices instead: tag the repo at year end (`git tag fy2025`) and review
any later changes to that year's file.

See also: [ledger cheatsheet](ledger-cheatsheet.md), [demo data](demo.md).
