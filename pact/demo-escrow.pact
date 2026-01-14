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

)
