# Rails Mocks

`Rails Mocks` Makes stubbing in your Rails application from an external resource easier.

The gem adds middleware to rails to execute [stubs](https://github.com/rspec/rspec-mocks/blob/main/README.md#method-stubs)
before make any query. It based on [rspec-mocks](https://github.com/rspec/rspec-mocks/blob/main/README.md) library.

## Install
```ruby
group :test do
  gem "rails_mocks", "~> 0.0.1"
end
```

## Available functionality

What we can execute before make request on the rails side:
```ruby
# Instead of User we can use any rails constant
# It can be name of service, model, controller, etc
allow(User).to receive(:name)
allow(Book).to receive(:title).and_return("The Book")
allow(OrderService).to receive(:new).with(sum: 543).and_return(double(total: 543, id: 1))
allow(SumService).to receive(:new).with(double(a: 1, b: 5, c: 4)).and_return(double(sum: 10))
```

## Usage

To stub something from external resource we should set header `RAILS_MOCKS` in the http request with the syntax below.

```javascript
req.headers["RAILS_MOCKS"] = JSON.stringify([
    {
        allow: "User",
        receive: "name"
    },
    
    {
        allow: "Book",
        receive: "title",
        and_return: { body: "The Book" }
    },
    
    {
        allow: "OrderService",
        receive: "new",
        with: { body: { sum: 543 } },
        and_return: { body: { total: 543, id: 1 }, double: true }
    },
    
    {
        allow: "SumService",
        receive: "new",
        with: { body: { a: 1, b: 5, c: 4 }, double: true },
        and_return: { body: { sum: 10 }, double: true }
    }
])
```

### Cypress

Here the example how to stub Stripe from cypress:

```javascript
describe("when do refund", function() {
    beforeEach(function () {
        const chargeID = "frefef-43referf-43fref"
        
        cy.intercept("*", req => {
            req.headers["RAILS_MOCKS"] = JSON.stringify([
                {
                    allow: "Stripe::Refund",
                    receive: "create",
                    with: { body: { charge: chargeID }},
                    and_return: { body: { source: chargeID, status: "refunded" }, double: true}
                }
            ])
        })
    })

    it("then we click on the button and make refund",function() {
        
    })
})
```

We can use `cy.intercept` to modify headers of any request from the front-end application.
But if we want to make stub when do `cy.request` we should set headers in the cy.request [source](https://docs.cypress.io/api/commands/intercept#Controlling-the-outgoing-request): 

```javascript
cy.request({
    method: "POST",
    headers: {
      RAILS_MOCKS: JSON.stringify([
        {
          allow: "User",
          receive: "create"
        }
      ])
    },
    url: "/users",
    body: body
  })
```


