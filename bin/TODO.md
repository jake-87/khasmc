# Issues

currently working on polymorphic typechecking, just finished making functions to get the left and right of a given typesig.

current issues involve:
- ad hoc needs some sort of system to loop over the various type sigs and find a correct one
- all typevars need to be made unique bc. otherwise it will cause issues with stuff like
  ```
  ∀a, (∀a, a -> a) -> a
  ```
  bc the outside and inside a are different typevars, but are currently interpreted as the same typevar
  solution: transform it to something like
  ```
  ∀a1, (∀a2, a2 -> a2) -> a1
  ```
- currently, typechecking is barely started due to needing to deal with above issues, but it'll get there
- parametric polymorphism is easy, it's the ad hoc that's the problem lol