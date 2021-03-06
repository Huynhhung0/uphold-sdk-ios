import XCTest
import ObjectMapper
import PromiseKit
import KeychainSwift
@testable import UpholdSdk
@testable import SwiftClient

/// UpholdClient integration tests.
class UpholdClientTest: UpholdTestCase {

    override func tearDown() {
        super.tearDown()

        MockSessionManager.sharedInstance.invalidateSession()
    }

    func testCompleteAuthorizationShouldReturnEmptyCodeError() {
        let testExpectation = expectation(description: "Uphold client authorization test.")

        let authenticationResponse = AuthenticationResponse(accessToken: "foo", expiresIn: 1234, scope: "foobar", tokenType: "bar")
        let authorizationViewController = AuthorizationViewController(url: URL(string: "http://foo.bar")!, entersReaderIfAvailable: false)
        let client = UpholdClient()
        client.token.adapter = MockRestAdapter(body: Mapper().toJSONString(authenticationResponse)!)

        client.completeAuthorization(authorizationViewController: authorizationViewController, clientId: "foo", clientSecret: "bar", grantType: "foobiz", state: "foobar", uri: URL(string: "uphold://foobar.com?state=foobar")!).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "URL query parameter code should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCompleteAuthorizationShouldReturnEmptyStateError() {
        let testExpectation = expectation(description: "Uphold client authorization test.")

        let authenticationResponse = AuthenticationResponse(accessToken: "foo", expiresIn: 1234, scope: "foobar", tokenType: "bar")
        let authorizationViewController = AuthorizationViewController(url: URL(string: "http://foo.bar")!, entersReaderIfAvailable: false)
        let client = UpholdClient()
        client.token.adapter = MockRestAdapter(body: Mapper().toJSONString(authenticationResponse)!)

        client.completeAuthorization(authorizationViewController: authorizationViewController, clientId: "foo", clientSecret: "bar", grantType: "foobiz", state: "foobar", uri: URL(string: "uphold://foobar.com?code=foo")!).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "URL query parameter state should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCompleteAuthorizationShouldReturnTheAuthenticationResponse() {
        let testExpectation = expectation(description: "Uphold client authorization test.")

        let authenticationResponse = AuthenticationResponse(accessToken: "foo", expiresIn: 1234, scope: "foobar", tokenType: "bar")
        let authorizationViewController = AuthorizationViewController(url: URL(string: "http://foo.bar")!, entersReaderIfAvailable: false)
        let client = UpholdClient()
        client.token.adapter = MockRestAdapter(body: Mapper().toJSONString(authenticationResponse)!)

        client.completeAuthorization(authorizationViewController: authorizationViewController, clientId: "foo", clientSecret: "bar", grantType: "foobiz", state: "foobar", uri: URL(string: "uphold://foobar.com?code=foo&state=foobar")!).then { (authenticationResponse: AuthenticationResponse) -> Void in

            XCTAssertEqual(authenticationResponse.accessToken, "foo", "Failed: Wrong access token.")
            XCTAssertEqual(authenticationResponse.expiresIn, 1234, "Failed: Wrong expiration time.")
            XCTAssertEqual(authenticationResponse.scope, "foobar", "Failed: Wrong scope.")
            XCTAssertEqual(authenticationResponse.tokenType, "bar", "Failed: Wrong token type.")

            testExpectation.fulfill()
        }.catch(execute: { (_: Error) in
            XCTFail("Uphold client authorization test error.")
        })

        wait()
    }

    func testGetTickersShouldReturnTheArrayOfTickers() {
        let testExpectation = expectation(description: "Uphold client test.")

        let json: String = "[{" +
            "\"ask\": \"foo\"," +
            "\"bid\": \"bar\"," +
            "\"currency\": \"foobar\"," +
            "\"pair\": \"foobiz\"" +
        "}, {" +
            "\"ask\": \"fiz\"," +
            "\"bid\": \"biz\"," +
            "\"currency\": \"foobiz\"," +
            "\"pair\": \"bar\"" +
        "}, {" +
            "\"ask\": \"foobar\"," +
            "\"bid\": \"foobaz\"," +
            "\"currency\": \"bar\"," +
            "\"pair\": \"foo\"" +
        "}]"
        let client = UpholdClient()
        client.token.adapter = MockRestAdapter(body: json)

        client.getTickers().then { (rates: [Rate]) -> Void in
            XCTAssertEqual(rates.count, 3, "Failed: Wrong response object size.")
            XCTAssertEqual(rates[0].ask, "foo", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[0].bid, "bar", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[0].currency, "foobar", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[0].pair, "foobiz", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[1].ask, "fiz", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[1].bid, "biz", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[1].currency, "foobiz", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[1].pair, "bar", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[2].ask, "foobar", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[2].bid, "foobaz", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[2].currency, "bar", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[2].pair, "foo", "Failed: Wrong response object attribute.")

            testExpectation.fulfill()
            }.catch(execute: { (_: Error) in
            XCTFail("Uphold client test error.")
        })

        wait()
    }

    func testGetTickersByCurrencyShouldReturnTheArrayOfTickers() {
        let testExpectation = expectation(description: "Uphold client test.")

        let json: String = "[{" +
            "\"ask\": \"foo\"," +
            "\"bid\": \"bar\"," +
            "\"currency\": \"foobar\"," +
            "\"pair\": \"foobiz\"" +
        "}, {" +
            "\"ask\": \"fiz\"," +
            "\"bid\": \"biz\"," +
            "\"currency\": \"foobiz\"," +
            "\"pair\": \"bar\"" +
        "}, {" +
            "\"ask\": \"foobar\"," +
            "\"bid\": \"foobaz\"," +
            "\"currency\": \"bar\"," +
            "\"pair\": \"foo\"" +
        "}]"
        let client = UpholdClient()
        client.token.adapter = MockRestAdapter(body: json)

        client.getTickersByCurrency(currency: "USD").then { (rates: [Rate]) -> Void in
            XCTAssertEqual(rates.count, 3, "Failed: Wrong response object size.")
            XCTAssertEqual(rates[0].ask, "foo", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[1].ask, "fiz", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[2].ask, "foobar", "Failed: Wrong response object attribute.")

            testExpectation.fulfill()
        }.catch(execute: { (_: Error) in
            XCTFail("Uphold client test error.")
        })

        wait()
    }

    func testGetUserShouldReturnTheUser() {
        let testExpectation = expectation(description: "Uphold client test.")

        let json: String = "{" +
            "\"username\": \"foobar\"," +
            "\"email\": \"foo@bar.org\"," +
            "\"firstName\": \"foo\"," +
            "\"lastName\": \"bar\"," +
            "\"memberAt\": \"bizdev\"," +
            "\"name\": \"Foo Bar\"," +
            "\"country\": \"BAR\"," +
            "\"state\": \"FOO\"," +
            "\"currencies\": [" +
                "\"BTC\"" +
            "]," +
            "\"status\": \"ok\"," +
            "\"settings\": {" +
                "\"theme\": \"minimalistic\"," +
                "\"currency\": \"USD\"," +
                "\"hasMarketingConsent\": true," +
                "\"hasNewsSubscription\": true," +
                "\"intl\": {" +
                    "\"language\": {" +
                        "\"locale\": \"en-US\"" +
                    "}," +
                    "\"dateTimeFormat\": {" +
                        "\"locale\": \"en-US\"" +
                    "}," +
                    "\"numberFormat\": {" +
                        "\"locale\": \"en-US\"" +
                    "}" +
                "}," +
                "\"otp\": {" +
                    "\"login\": {" +
                        "\"enabled\": false" +
                    "}," +
                    "\"transactions\": {" +
                        "\"send\": {" +
                            "\"enabled\": false" +
                        "}," +
                        "\"transfer\": {" +
                            "\"enabled\": true" +
                        "}," +
                        "\"withdraw\": {" +
                            "\"crypto\": {" +
                                "\"enabled\": true" +
                            "}" +
                        "}" +
                    "}" +
                "}" +
            "}," +
            "\"verifications\": {" +
                "\"address\": {" +
                    "\"reason\": \"foo\"," +
                    "\"status\": \"bar\"" +
                "}," +
                "\"birthdate\": {" +
                    "\"reason\": \"fiz\"," +
                    "\"status\": \"biz\"" +
                "}," +
                "\"documents\": {" +
                    "\"reason\": \"fuz\"," +
                    "\"status\": \"buz\"" +
                "}," +
                "\"email\": {" +
                    "\"reason\": \"foobar\"," +
                    "\"status\": \"foobuz\"" +
                "}," +
                "\"identity\": {" +
                    "\"reason\": \"bar\"," +
                    "\"status\": \"biz\"" +
                "}," +
                "\"location\": {" +
                    "\"reason\": \"biz\"," +
                    "\"status\": \"buz\"" +
                "}," +
                "\"marketing\": {" +
                    "\"reason\": \"foobar\"," +
                    "\"status\": \"foo\"" +
                "}," +
                "\"phone\": {" +
                    "\"reason\": \"fizbuz\"," +
                    "\"status\": \"fuzbuz\"" +
                "}," +
                "\"terms\": {" +
                    "\"reason\": \"foobar\"," +
                    "\"status\": \"fizbiz\"" +
                "}" +
            "}" +
        "}"
        let client = MockUpholdClient(bearerToken: "foobar")
        client.mockToken.mockAdapter = MockRestAdapter(body: json)

        client.getUser().then { (user: User) -> Void in
            XCTAssertEqual(user.country, "BAR", "Failed: User country didn't match.")
            XCTAssertEqual(user.currencies!.count, 1, "Failed: User currencies didn't match.")
            XCTAssertEqual(user.currencies![0], "BTC", "Failed: User currencies didn't match.")
            XCTAssertEqual(user.email, "foo@bar.org", "Failed: User email didn't match.")
            XCTAssertEqual(user.firstName, "foo", "Failed: User first name didn't match.")
            XCTAssertEqual(user.lastName, "bar", "Failed: User last name didn't match.")
            XCTAssertEqual(user.memberAt, "bizdev", "Failed: User memberAt didn't match.")
            XCTAssertEqual(user.name, "Foo Bar", "Failed: User name didn't match.")
            XCTAssertEqual(user.settings!.currency!, "USD", "Failed: User settings currency didn't match.")
            XCTAssertTrue(user.settings!.hasMarketingConsent!, "Failed: User settings hasMarketingConsent didn't match.")
            XCTAssertTrue(user.settings!.hasNewsSubscription!, "Failed: User settings hasNewsSubscription didn't match.")
            XCTAssertEqual(user.settings!.intl!.dateTimeFormat!.locale!, "en-US", "Failed: User settings intl dateTimeFormat didn't match.")
            XCTAssertEqual(user.settings!.intl!.language!.locale!, "en-US", "Failed: User settings intl language didn't match.")
            XCTAssertEqual(user.settings!.intl!.numberFormat!.locale!, "en-US", "Failed: User settings intl numberFormat didn't match.")
            XCTAssertFalse(user.settings!.otp!.login!.enabled!, "Failed: User settings otp login didn't match.")
            XCTAssertFalse(user.settings!.otp!.transactions!.send!.enabled!, "Failed: User settings otp transactions send didn't match.")
            XCTAssertTrue(user.settings!.otp!.transactions!.transfer!.enabled!, "Failed: User settings otp transactions transfer didn't match.")
            XCTAssertTrue(user.settings!.otp!.transactions!.withdraw!.crypto!.enabled!, "Failed: User settings otp login didn't match.")
            XCTAssertEqual(user.settings!.theme!, "minimalistic", "Failed: User settings theme didn't match.")
            XCTAssertEqual(user.state, "FOO", "Failed: User name didn't match.")
            XCTAssertEqual(user.status, "ok", "Failed: User name didn't match.")
            XCTAssertEqual(user.username, "foobar", "Failed: User name didn't match.")
            XCTAssertEqual(user.verifications!.address?.reason, "foo", "Failed: Address reason didn't match.")
            XCTAssertEqual(user.verifications!.address?.status, "bar", "Failed: Address status didn't match.")
            XCTAssertEqual(user.verifications!.birthdate?.reason, "fiz", "Failed: Birthdate reason didn't match.")
            XCTAssertEqual(user.verifications!.birthdate?.status, "biz", "Failed: Birthdate status didn't match.")
            XCTAssertEqual(user.verifications!.documents?.reason, "fuz", "Failed: Documents reason didn't match.")
            XCTAssertEqual(user.verifications!.documents?.status, "buz", "Failed: Documents status didn't match.")
            XCTAssertEqual(user.verifications!.email?.reason, "foobar", "Failed: Email reason didn't match.")
            XCTAssertEqual(user.verifications!.email?.status, "foobuz", "Failed: Email status didn't match.")
            XCTAssertEqual(user.verifications!.identity?.reason, "bar", "Failed: Identity reason didn't match.")
            XCTAssertEqual(user.verifications!.identity?.status, "biz", "Failed: Identity status didn't match.")
            XCTAssertEqual(user.verifications!.location?.reason, "biz", "Failed: Location reason didn't match.")
            XCTAssertEqual(user.verifications!.location?.status, "buz", "Failed: Location status didn't match.")
            XCTAssertEqual(user.verifications!.marketing?.reason, "foobar", "Failed: Marketing reason didn't match.")
            XCTAssertEqual(user.verifications!.marketing?.status, "foo", "Failed: Marketing status didn't match.")
            XCTAssertEqual(user.verifications!.phone?.reason, "fizbuz", "Failed: Phone reason didn't match.")
            XCTAssertEqual(user.verifications!.phone?.status, "fuzbuz", "Failed: Phone status didn't match.")
            XCTAssertEqual(user.verifications!.terms?.reason, "foobar", "Failed: Terms reason didn't match.")
            XCTAssertEqual(user.verifications!.terms?.status, "fizbiz", "Failed: Terms status didn't match.")

            testExpectation.fulfill()
        }.catch(execute: { (_: Error) in
            XCTFail("Uphold client test error.")
        })

        wait()
    }

    func testInvalidateSessionShouldInvalidateSession() {
        let client = UpholdClient(bearerToken: "foo")

        client.invalidateSession()

        let request = client.token.adapter.buildRequest(request: TickerService.getAllTickers())

        XCTAssertNil(request.headers["authorization"], "Failed: Wrong header.")
        XCTAssertNil(KeychainSwift().get(SessionManager.KEYCHAIN_TOKEN_KEY), "Failed: Wrong token.")
    }

}
