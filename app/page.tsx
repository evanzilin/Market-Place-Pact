'use client'
import { useState } from 'react'
import "./globals.css";

const callPact = async (fn: string, args: any[]) => {
  console.log('Calling Pact:', fn, args)
  alert(`Demo call → ${fn}(${args.join(', ')})`)
  // Later:
  // - connect wallet
  // - sign tx
  // - submit to Kadena node
};

export default function Home() {
  const [id, setId] = useState('')
  const [amount, setAmount] = useState('')

  return (
    <main className="min-h-screen bg-gray-950 text-gray-100 flex justify-center items-center">
      <div className="bg-gray-900 p-6 rounded-2xl w-full max-w-md space-y-4">
        <h1 className="text-xl font-semibold">Kadena Escrow Demo</h1>

        <input
          className="w-full p-2 rounded bg-gray-800"
          placeholder="Escrow ID"
          value={id}
          onChange={e => setId(e.target.value)}
        />

        <input
          className="w-full p-2 rounded bg-gray-800"
          placeholder="Amount (KDA)"
          value={amount}
          onChange={e => setAmount(e.target.value)}
        />

        <div className="grid grid-cols-2 gap-2">
          <button onClick={() => callPact('create', [id, amount])} className="btn">Create</button>
          <button onClick={() => callPact('accept', [id])} className="btn">Accept</button>
          <button onClick={() => callPact('deposit', [id])} className="btn">Deposit</button>
          <button onClick={() => callPact('paid', [id])} className="btn">Paid</button>
          <button onClick={() => callPact('release', [id])} className="btn col-span-2">Release</button>
        </div>
      </div>
    </main>
  )
}
