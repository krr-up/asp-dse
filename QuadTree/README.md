Usage: `python3 QuadTree.py <nbr of dimensions> <nbr of steps> <nbr of partial solutions> <solution step> <timeout> <order>`

|Arg|Meaning|
|--|--|
|`<nbr of dimensions>`       | Dimensionality of the generated front                   |
|`<nbr of steps>`            | Number of solutions on the front (the more, the closer) |
|`<nbr of partial solutions>`| Determines the number of partial solutions per solution |
|`<solution step>`           | Determines the number of dominated solutions (the smaller, the larger the number of vectors)
| `<timeout>`                | Determines the maximum allowed run time of the benchmark|
| `<order>` | may be `i` (inversely ordered), `o` (ordered), or `u` (unordered)