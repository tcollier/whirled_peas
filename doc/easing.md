## Easing

The duration that a frame within a frameset is displayed is determined by the easing function and effect along with the frames relative position within the frameset. The three effects are

- `:in` - apply easing only to the start of the frameset
- `:out` - apply easing only to the end of the frameset
- `:in_out` - apply easing to the start and end of the frameset

The available easing functions are

- `:bezier`

```
# bezier (in)
┃                                                         ▄▀
┃                                                      ▄▄▀
┃                                                    ▄▀
┃                                                 ▄▀▀
┃                                              ▄▄▀
┃                                           ▄▄▀
┃                                        ▄▄▀
┃                                      ▄▀
┃                                  ▄▄▀▀
┃                               ▄▄▀
┃                            ▄▀▀
┃                        ▄▄▀▀
┃                   ▄▄▀▀▀
┃             ▄▄▄▀▀▀
┃▄▄▄▄▄▄▄▄▄▄▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# bezier (out)
┃                                               ▄▄▄▀▀▀▀▀▀▀▀▀
┃                                         ▄▄▄▀▀▀
┃                                    ▄▄▄▀▀
┃                                ▄▄▀▀
┃                             ▄▄▀
┃                          ▄▀▀
┃                      ▄▄▀▀
┃                    ▄▀
┃                 ▄▀▀
┃              ▄▀▀
┃           ▄▀▀
┃        ▄▄▀
┃      ▄▀
┃   ▄▀▀
┃▄▄▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# bezier (in_out)
┃                                                  ▄▄▄▀▀▀▀▀▀
┃                                              ▄▄▀▀
┃                                           ▄▀▀
┃                                        ▄▀▀
┃                                     ▄▀▀
┃                                  ▄▀▀
┃                               ▄▄▀
┃                             ▄▀
┃                          ▄▀▀
┃                       ▄▄▀
┃                    ▄▄▀
┃                 ▄▄▀
┃              ▄▄▀
┃          ▄▄▀▀
┃▄▄▄▄▄▄▄▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

`:linear`

```
# linear (in)
┃                                                        ▄▄▀
┃                                                    ▄▄▀▀
┃                                                ▄▄▀▀
┃                                            ▄▄▀▀
┃                                        ▄▄▀▀
┃                                    ▄▄▀▀
┃                                ▄▄▀▀
┃                            ▄▄▀▀
┃                        ▄▄▀▀
┃                    ▄▄▀▀
┃                ▄▄▀▀
┃            ▄▄▀▀
┃        ▄▄▀▀
┃    ▄▄▀▀
┃▄▄▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# linear (out)
┃                                                        ▄▄▀
┃                                                    ▄▄▀▀
┃                                                ▄▄▀▀
┃                                            ▄▄▀▀
┃                                        ▄▄▀▀
┃                                    ▄▄▀▀
┃                                ▄▄▀▀
┃                            ▄▄▀▀
┃                        ▄▄▀▀
┃                    ▄▄▀▀
┃                ▄▄▀▀
┃            ▄▄▀▀
┃        ▄▄▀▀
┃    ▄▄▀▀
┃▄▄▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# linear (in_out)
┃                                                        ▄▄▀
┃                                                    ▄▄▀▀
┃                                                ▄▄▀▀
┃                                            ▄▄▀▀
┃                                        ▄▄▀▀
┃                                    ▄▄▀▀
┃                                ▄▄▀▀
┃                            ▄▄▀▀
┃                        ▄▄▀▀
┃                    ▄▄▀▀
┃                ▄▄▀▀
┃            ▄▄▀▀
┃        ▄▄▀▀
┃    ▄▄▀▀
┃▄▄▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

`:parametric`

```
# parametric (in)
┃                                                          ▄
┃                                                        ▄▀
┃                                                      ▄▀
┃                                                   ▄▄▀
┃                                                 ▄▀
┃                                               ▄▀
┃                                             ▄▀
┃                                          ▄▄▀
┃                                        ▄▀
┃                                     ▄▀▀
┃                                  ▄▀▀
┃                              ▄▄▀▀
┃                         ▄▄▄▀▀
┃                   ▄▄▄▄▀▀
┃▄▄▄▄▄▄▄▄▄▄▄▄▄▄▀▀▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# parametric (out)
┃                                         ▄▄▄▄▄▀▀▀▀▀▀▀▀▀▀▀▀▀
┃                                   ▄▄▀▀▀▀
┃                              ▄▄▀▀▀
┃                          ▄▄▀▀
┃                       ▄▄▀
┃                    ▄▄▀
┃                  ▄▀
┃               ▄▀▀
┃             ▄▀
┃           ▄▀
┃         ▄▀
┃      ▄▀▀
┃    ▄▀
┃  ▄▀
┃▄▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# parametric (in_out)
┃                                               ▄▄▄▀▀▀▀▀▀▀▀▀
┃                                           ▄▄▀▀
┃                                        ▄▀▀
┃                                     ▄▄▀
┃                                   ▄▀
┃                                 ▄▀
┃                               ▄▀
┃                             ▄▀
┃                           ▄▀
┃                         ▄▀
┃                       ▄▀
┃                    ▄▀▀
┃                 ▄▄▀
┃             ▄▄▀▀
┃▄▄▄▄▄▄▄▄▄▄▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

`:quadratic`

```
# quadratic (in)
┃                                                         ▄▄
┃                                                       ▄▀
┃                                                     ▄▀
┃                                                   ▄▀
┃                                                 ▄▀
┃                                              ▄▀▀
┃                                            ▄▀
┃                                         ▄▀▀
┃                                      ▄▀▀
┃                                   ▄▀▀
┃                               ▄▄▀▀
┃                           ▄▄▀▀
┃                      ▄▄▄▀▀
┃                ▄▄▄▀▀▀
┃▄▄▄▄▄▄▄▄▄▄▄▀▀▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# quadratic (out)
┃                                            ▄▄▄▄▄▀▀▀▀▀▀▀▀▀▀
┃                                      ▄▄▄▀▀▀
┃                                 ▄▄▀▀▀
┃                             ▄▄▀▀
┃                         ▄▄▀▀
┃                      ▄▄▀
┃                   ▄▄▀
┃                ▄▄▀
┃              ▄▀
┃           ▄▄▀
┃         ▄▀
┃       ▄▀
┃     ▄▀
┃   ▄▀
┃▄▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# quadratic (in_out)
┃                                                 ▄▄▄▀▀▀▀▀▀▀
┃                                            ▄▄▀▀▀
┃                                         ▄▀▀
┃                                      ▄▀▀
┃                                   ▄▄▀
┃                                 ▄▀
┃                               ▄▀
┃                             ▄▀
┃                           ▄▀
┃                         ▄▀
┃                      ▄▀▀
┃                   ▄▄▀
┃                ▄▄▀
┃           ▄▄▄▀▀
┃▄▄▄▄▄▄▄▄▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```