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

)
