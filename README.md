# StockPortfolio for MoneyMoney
Create a custom stock portfolio and fetch the current stock value via finnhub.io

![MoneyMoney screenshot with StockPortfolio Balance](screens/StockPortfolio-balance.png)

## Extension Setup

1. Download the extension via the [GitHub releases page](https://github.com/tobiasdueser/MoneyMoney-StockPortfolio/releases/tag/v1.0)
2. Once downloaded, move `StockPortfolio.lua` to your MoneyMoney Extensions folder.
3. Create a free [finnhub.io](https://finnhub.io/) account and copy the API-key from [finnhub.io/dashboard](https://finnhub.io/dashboard)

Currently the extension is not signed by MoneyMoney, so you have to disable verification in the settings.

## MoneyMoney Setup

Add a new account (type "StockPortfolio").

**Use the stock symbols comma seperated with the number of shares in brackets as user name**
`AAPL(0.7),TSLA(1.5)` (example)

**Use free Finnhub API key as password**
`5r8ufep1br56mlvrhj6g` (example)

![MoneyMoney screenshot with StockPortfolio Setup](screens/StockPortfolio-setup.png)

### Bonus
Add buying rate via MoneyMoney (Right click on stock) to display the profit.
