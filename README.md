# sorbet_sig_performance

<h2>Context</h2>

We noticed significant hits to the performance of the CMS build ([~7min](https://buildkite.com/gusto/payroll-reference-data-cms/builds/3075) to [~10 min](https://buildkite.com/gusto/payroll-reference-data-cms/builds/3145)) after merging [this commit](https://github.com/Gusto/payroll_reference_data_cms/pull/499/commits/2185d6ead3d5c7d9b51f68f53c3aa95bdadb871b),
which introduced Sorbet's runtime type checking signatures on some large hashes in the overrides file. To give an idea of the sizes of the hashes:

```
7 overrides loaded for county_name_overrides
4741 overrides loaded for school_name_overrides
2 overrides loaded for payable_overrides
11 overrides loaded for exemptable_overrides
5 overrides loaded for allow_negative_amount_overrides
4503 overrides loaded for force_unpaid_mid_quarter_overrides
3448 overrides loaded for payment_agency_mt_id_overrides
2737 overrides loaded for report_agency_mt_id_overrides
1730 overrides loaded for ein_format_overrides
3 overrides loaded for hourly_overrides
4552 overrides loaded for psd_code_overrides
6 overrides loaded for reference_ein_format_overrides
58 overrides loaded for deposit_schedule_property_overrides
87 overrides loaded for deposit_schedule_overrides
65 overrides loaded for phone_overrides
7 overrides loaded for priority_overrides
7 overrides loaded for required_for_pts_overrides
8 overrides loaded for zp_tax_group_overrides
```

We suspected that the runtime checks could be the culprit for the performance hit, and experimented running the .spec 
with and without the method signatures on the larger (1000+ key) hashes in the file. The performance improved significantly: from ~3.5 min to ~1.5 min.

<h2>Benchmarks</h2>

When large hashes are fetched and type-checked at runtime, Sorbet has to run checks on every member in hash- which is more expensive than expected.
We have observed a linear degradation in performance when comparing the time it takes to read a hash with a sig vs. a hash with `.checked(:never)` ([doesn't run runtime checks](https://sorbet.org/docs/runtime#checked-whether-to-check-in-the-first-place)) specified.
For a `Hash[String, String]`:

| # of keys  |  Avg Method Calls/5 seconds (with sig) | Avg Method calls/5 seconds (sig never checked)  | Order of Magnitude of diff  |   |
|---|---|---|---|---|
| 5  | 454,777  |  2,308,000 | 1|
|  50 | 643,000  | 86,662,000  |  2| 
|  5000 | 7,020  |  96,780,000 | 4| 


Here's the raw output observed when running [benchmarking tests](https://github.com/bbuchalter/sorbet_sig_performance/blob/master/sorbet_test.rb) on the different sized hashes described above: 

```
~/workspace/sorbet_sig_performance (master)$ ruby sorbet_test.rb
preparing hash with 5000 keys (string) whose values are also strings...
starting benchmark
Warming up --------------------------------------
       hash_with_sig   135.000  i/100ms
Calculating -------------------------------------
       hash_with_sig      1.420k (±13.5%) i/s -      7.020k in   5.050230s
Warming up --------------------------------------
    hash_without_sig     1.776M i/100ms
Calculating -------------------------------------
    hash_without_sig     22.579M (± 4.8%) i/s -    113.668M in   5.047361s
Warming up --------------------------------------
hash_with_sig_never_checked
                         1.888M i/100ms
Calculating -------------------------------------
hash_with_sig_never_checked
                         19.490M (± 2.5%) i/s -     98.159M in   5.039484s



preparing hash with 50 keys (string) whose values are also strings...
starting benchmark
Warming up --------------------------------------
       hash_with_sig    12.860k i/100ms
Calculating -------------------------------------
       hash_with_sig    127.482k (± 2.4%) i/s -    643.000k in   5.046677s
Warming up --------------------------------------
    hash_without_sig     2.333M i/100ms
Calculating -------------------------------------
    hash_without_sig     23.303M (± 2.2%) i/s -    116.670M in   5.009138s
Warming up --------------------------------------
hash_with_sig_never_checked
                         1.699M i/100ms
Calculating -------------------------------------
hash_with_sig_never_checked
                         17.500M (± 9.7%) i/s -     86.662M in   5.020356s



preparing hash with 5 keys (string) whose values are also strings...
starting benchmark
Warming up --------------------------------------
       hash_with_sig    46.168k i/100ms
Calculating -------------------------------------
       hash_with_sig    454.744k (± 4.6%) i/s -      2.308M in   5.087623s
Warming up --------------------------------------
    hash_without_sig     2.277M i/100ms
Calculating -------------------------------------
    hash_without_sig     21.755M (± 4.5%) i/s -    109.318M in   5.034857s
Warming up --------------------------------------
hash_with_sig_never_checked
                         1.936M i/100ms
Calculating -------------------------------------
hash_with_sig_never_checked
                         19.209M (± 4.3%) i/s -     96.780M in   5.047838s
```

After observing this behavior, we came to the conclusion that removing the runtime checks on larger hashes (while keeping the static analysis) that Sorbet provides via `.checked(:never)` is the best option we have to avoid the performance hits.
