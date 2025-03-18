module MyModule::LeaseAgreement {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a lease agreement.
    struct Lease has store, key {
        landlord: address,
        tenant: address,
        rent_amount: u64,
    }

    /// Function to create a new lease agreement.
    public fun create_lease(landlord: &signer, tenant: address, rent_amount: u64) {
        let lease = Lease {
            landlord: signer::address_of(landlord),
            tenant,
            rent_amount,
        };
        move_to(landlord, lease);
    }

    /// Function for the tenant to pay rent to the landlord.
    public fun pay_rent(tenant: &signer, landlord: address, amount: u64) acquires Lease {
        let lease = borrow_global<Lease>(landlord);
        assert!(lease.tenant == signer::address_of(tenant), 1);
        assert!(amount == lease.rent_amount, 2);

        let payment = coin::withdraw<AptosCoin>(tenant, amount);
        coin::deposit<AptosCoin>(landlord, payment);
    }
}
