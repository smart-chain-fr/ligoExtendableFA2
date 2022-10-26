#import "../lib/single_asset/fa2.mligo" "FA2"

type storage = FA2.storage

type extension = {
    admin : address;
    probationary_period : timestamp;
}

type extended_storage = extension storage

type parameter = [@layout:comb]
    | Transfer of FA2.transfer
    | Balance_of of FA2.balance_of
    | Update_operators of FA2.update_operators

let authorize_transfer (s : extended_storage) : unit =
    let sender_ = Tezos.get_sender() in
    if ( (not (sender_ = s.extension.admin)) && (Tezos.get_now() < s.extension.probationary_period) )
    then
        failwith "Transfer not authorized for users before Probationary Period"
    else
        ()

let main (p, s : parameter * extended_storage) : operation list * extended_storage =
    match p with
        Transfer                   p -> let _ = authorize_transfer s in
                                        FA2.transfer p s
        | Balance_of               p -> FA2.balance_of p s
        | Update_operators         p -> FA2.update_ops p s

let get_balance (s : extended_storage) (owner : address) (_token_id : nat) : nat =
    FA2.Ledger.get_for_user s.ledger owner

[@view] let get_balance (p, s : address * extended_storage) : nat =
    get_balance s p 0n
