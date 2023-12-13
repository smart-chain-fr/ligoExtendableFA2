#import "../lib/single_asset/fa2.mligo" "FA2"

type storage = FA2.storage
type extension = string
type extended_storage = extension storage

type parameter =
    | Transfer of FA2.transfer
    | Balance_of of FA2.balance_of
    | Update_operators of FA2.update_operators

[@entry]
let transfer (p: FA2.transfer) (s: extended_storage) : operation list * extended_storage =
  FA2.transfer p s

[@entry]
let balance_of (p: FA2.balance_of) (s: extended_storage) : operation list * extended_storage =
  FA2.balance_of p s

[@entry]
let update_operators (p: FA2.update_operators) (s: extended_storage) : operation list * extended_storage =
  FA2.update_ops p s
