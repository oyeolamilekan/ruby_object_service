class PaymentService

    attr_accessor :platform_name

    def initialize(platform_name)
        @platform_name = platform_name

        payment_providers = {
            adyen: Adyen.new(),
            stripe: Stripe.new()
        }

        if payment_providers.key?(platform_name)
            @platform_wrapper = payment_providers[platform_name]
            return @platform_wrapper
        end
        raise StandardError.new 'We currently don\'t support that payment provider'
    end

    def charge_platform_card(card_number, cvv, pin)
        @platform_wrapper.charge_card(card_number, cvv, pin)
    end

    def disburse_platform_funds(ach_number, country)
        @platform_wrapper.disburse_funds(ach_number, country)
    end
    
end


class Adyen
    def charge_card(card_number, cvv, pin)
        return "charging card from #{card_number} adyen network"
    end

    def disburse_funds(ach_number, country)
        return "disburse funds from Adyen #{ach_number} in #{country}."
    end
end

class Stripe
    def charge_card(card_number, cvv, pin)
        return "charging card number #{card_number} from stripe network"
    end

    def disburse_funds(ach_number, country)
        return "disburse funds from Stripe #{ach_number} in #{country}."
    end
end

def charge_card_controller()
    begin
        charge_object = PaymentService.new(:adyen)

        charge_message = charge_object.charge_platform_card(2333333444233, 200, 1234)

        puts({ status: "success", message: charge_message, data: nil})
    rescue StandardError => e
        puts({ status: "failed", message: e.message, data: nil })
    end
end

def disburse_funds_controller()
    begin
        payout_object = PaymentService.new(:stripe)

        payout_message = payout_object.disburse_platform_funds(2333333444233, 'US')

        puts({ status: "success", message: payout_message, data: nil})
    rescue StandardError => e
        puts({ status: "failed", message: e.message, data: nil })
    end
end

charge_card_controller()
disburse_funds_controller()