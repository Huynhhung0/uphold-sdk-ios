import Foundation
import ObjectMapper

/// Parameters model.
public class Parameters: Mappable {

    /// The transaction currency.
    public private(set) var currency: String?

    /// The transaction margin.
    public private(set) var margin: String?

    /// The transaction pair.
    public private(set) var pair: String?

    /// The transaction progress.
    public private(set) var progress: String?

    /// The transaction rate.
    public private(set) var rate: String?

    /// The transaction refunds information.
    public private(set) var refunds: String?

    /// The transaction ttl.
    public private(set) var ttl: Int?

    /// The transaction txid.
    public private(set) var txid: String?

    /// The transaction type.
    public private(set) var type: String?

    /**
      Constructor.

      - parameter currency: The transaction currency.
      - parameter margin: The transaction margin.
      - parameter pair: The transaction pair.
      - parameter progress: The transaction progress.
      - parameter rate: The transaction rate.
      - parameter refunds: The transaction refunds information.
      - parameter ttl: The transaction ttl.
      - parameter txid: The transaction txid.
      - parameter type: The transaction type.
    */
    public init(currency: String, margin: String, pair: String, progress: String, rate: String, refunds: String, ttl: Int, txid: String, type: String) {
        self.currency = currency
        self.margin = margin
        self.pair = pair
        self.progress = progress
        self.rate = rate
        self.refunds = refunds
        self.ttl = ttl
        self.txid = txid
        self.type = type
    }

    // MARK: Required by the ObjectMapper.

    /**
      Constructor.
    */
    required public init?(_ map: Map) {
    }

    /**
      Maps the JSON to the Object.

      - parameter map: The object to map.
    */
    public func mapping(map: Map) {
        currency  <- map["currency"]
        margin <- map["margin"]
        pair <- map["pair"]
        progress <- map["progress"]
        rate <- map["rate"]
        refunds <- map["refunds"]
        ttl <- map["ttl"]
        txid <- map["txid"]
        type <- map["type"]
    }

}
