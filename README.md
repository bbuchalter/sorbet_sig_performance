# sorbet_sig_performance

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
