module message_module::payment {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    struct Message has key, store {
        id: UID,
        sender: address,
        receiver: address,
        content: vector<u8>,
        timestamp: u64,
        amount: u64         // Amount of SUI sent with message
    }

    public fun send_message_with_payment(
        receiver: address,
        content: vector<u8>,
        payment: Coin<SUI>,
        ctx: &mut TxContext
    ) {
        let amount: u64 = coin::value(&payment);
        let sender = tx_context::sender(ctx);
        let timestamp = tx_context::epoch(ctx);
        
        let message = Message {
            id: object::new(ctx),
            sender,
            receiver,
            content,
            timestamp,
            amount
        };

        // Transfer the payment to receiver
        transfer::public_transfer(payment, receiver);
        
        // Transfer the message object
        transfer::transfer(message, receiver);
    }
}