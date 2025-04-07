# Hosts config

| Name         | Description                                       |
| ------------ | ------------------------------------------------- |
| `Enterprise` | AMD/Nvidia Desktop, main machine                  |
| `Apollo`     | Huawei Matebook X Pro 2017? Intel, laptop         |
| `rog`        | Temporary machine, used while `io` was in service |

All the hosts have a shared config in `modules/core.nix`. Host specific configs
are stored inside the specific host dir. Each host imports its own modules
inside `default.nix`.
