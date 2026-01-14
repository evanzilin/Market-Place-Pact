(module demo-escrow GOVERNANCE

  (deftable escrows:{escrow})

  (defschema escrow
    id:string
    seller:string
    buyer:string
    arbiter:string
    amount:decimal
    state:string
  )

  (defconst CREATED  "CREATED")
  (defconst ACCEPTED "ACCEPTED")
  (defconst FUNDED   "FUNDED")
  (defconst PAID     "PAID")
  (defconst DONE     "DONE")
  (defconst REFUND   "REFUND")

  (defun create (id:string amount:decimal arbiter:string)
    (enforce (> amount 0.0) "Amount must be positive")
    (insert escrows id
      { "id": id
      , "seller": (sender)
      , "buyer": ""
      , "arbiter": arbiter
      , "amount": amount
      , "state": CREATED
      })
  )

  (defun accept (id:string)
    (with-read escrows id { "seller": seller, "state": state }
      (do
        (enforce (= state CREATED) "Not available")
        (enforce (!= (sender) seller) "Seller cannot accept")
        (update escrows id
          { "buyer": (sender), "state": ACCEPTED })
      ))
  )

  (defun deposit (id:string)
    (with-read escrows id
      { "seller": seller, "amount": amount, "state": state }
      (do
        (enforce (= (sender) seller) "Only seller")
        (enforce (= state ACCEPTED) "Not accepted")
        (coin.transfer seller (module-account) amount)
        (update escrows id { "state": FUNDED })
      ))
  )

  (defun paid (id:string)
    (with-read escrows id { "buyer": buyer, "state": state }
      (do
        (enforce (= (sender) buyer) "Only buyer")
        (enforce (= state FUNDED) "Not funded")
        (update escrows id { "state": PAID })
      ))
  )

  (defun release (id:string)
    (with-read escrows id
      { "seller": seller, "buyer": buyer
      , "arbiter": arbiter, "amount": amount, "state": state }
      (do
        (enforce (= state PAID) "Not releasable")
        (enforce (or (= (sender) seller) (= (sender) arbiter))
          "Unauthorized")
        (coin.transfer (module-account) buyer amount)
        (update escrows id { "state": DONE })
      ))
  )

  (defun refund (id:string)
    (with-read escrows id
      { "seller": seller, "arbiter": arbiter
      , "amount": amount, "state": state }
      (do
        (enforce (= (sender) arbiter) "Only arbiter")
        (enforce (or (= state FUNDED) (= state PAID))
          "Refund not allowed")
        (coin.transfer (module-account) seller amount)
        (update escrows id { "state": REFUND })
      ))
  )
)
