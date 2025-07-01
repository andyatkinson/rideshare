# Rollups
<https://github.com/ankane/rollup>

## Example
- Rollups for new drivers created on the platform

Populate drivers over the last week:
```sh
bin/rails data_generators:drivers
```

Create rollups:
```sh
rails runner 'Driver.rollup("New drivers")'

Driver.rollup("New drivers", range: 1.week.ago.all_week)
```

Check driver counts for a day:
```
Rollup.series("New drivers")

Rollup.where(time: Date.yesterday).series("New drivers").values.last.to_i
```
