# AccountCache

## The Problem
We have a relatively expensive operation that lists the account balance and
aging schedule for all accounts with balances. Although this operation isn't
performed very often, it can take 30s to a minute to load this page. This is
both annoying for users and presents a heavy DB load all at once. And often we
are reloading/recalculating data that hasn't been recently changed.

## How Does Data Change?
In the real application, we have several methods that modify account balance.
1. A billable treatment is added to a visit associated with an account
2. A line item is added or edited on an existing invoice
3. A payment or refund is made against an account

## Some Options
1. Try try to maintain a coherent, completely up-to-date cache of the account
   data. That would mean that we'd recompute the balance and update the cache
each time any of the above events occurred.
2. Recompute the cache values periodically and sometimes show a slightly
   outdated account balance on this account summary page.

Given the relative importance of this data (out-of-date account balances is not
a safety issue) and the database impact of recomputing balances on every event
(at a busy practice, billable events could easily be happening many times per
minute), it seems best to periodically update the cache while alerting users
that the balance on the summary page, may be slightly out-of-date.

## Implementation Details
* Instead of recomputing the account balances from a list of invoices and
  payments/refunds each time we compute the balance summary, pull this data from
an ETC cache (account_ets).
* Each time an event occurs that might change the balance, store the account id
  in an ETS cache. Note that given that we are just storing a list of accounts
that have changed in a given period, we do no calculations here. We just add
that account_id to an ETS cache (event_ets).
* At a certain interval (2 minutes in this example), we pull a list of all
  account ids from event_ets, recompute the account balance and update
account_ets with the updated values. This means that we should be updating a
much smaller subset of accounts at this interval.
* At application startup, compute and cache the account balance for all accounts
  with a balance. This is a big operation but the same as the operation that was
being done on-demand when users requested it previously.

## Issues
* Should we use ETS? This may be a problem as we want a cache that is available
  across nodes in the clustered situation.
