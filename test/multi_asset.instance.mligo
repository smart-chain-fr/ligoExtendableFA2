#import "../lib/multi_asset/fa2.mligo" "FA2"

type storage = FA2.storage
type extension = string
type extended_storage = extension storage

type parameter = [@layout:comb]
    | Update_operators of FA2.update_operators
    | Balance_of of FA2.balance_of
    | Transfer of FA2.transfer

[@entry]
let transfer (p: FA2.transfer) (s: extended_storage) : operation list * extended_storage =
  FA2.transfer p s

[@entry]
let balance_of (p: FA2.balance_of) (s: extended_storage) : operation list * extended_storage =
  FA2.balance_of p s

[@entry]
let update_operators (p: FA2.update_operators) (s: extended_storage) : operation list * extended_storage =
  FA2.update_ops p s


// let main ((p,s):(parameter * extended_storage)): operation list * extended_storage = match p with
//    Transfer         p -> FA2.transfer   p s
// |  Balance_of       p -> FA2.balance_of p s
// |  Update_operators p -> FA2.update_ops p s
