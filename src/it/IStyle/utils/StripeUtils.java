package it.IStyle.utils;

import com.stripe.exception.StripeException;
import com.stripe.model.Refund;
import com.stripe.param.RefundCreateParams;

public class StripeUtils 
{

    public StripeUtils(){}


    public static Refund refundPayment(String paymentIntentId) throws StripeException 
    {
        // Prepara i parametri: rimborso sull'intero importo
        RefundCreateParams params = RefundCreateParams.builder()
            .setPaymentIntent(paymentIntentId)
            .build();

        // Crea e restituisce i dati sul rimborso rimborso
        return Refund.create(params);
    }
}


