-- Inofficial StockPortfolio Extension for MoneyMoney
-- Fetches Stock price via finnhub.io API
-- Fetches Current EUR/US exchange rate via exchangeratesapi.io API
-- Returns stocks as securities
--
-- Username: Stock symbol comma seperated with number of shares in brackets (Example: "AAPL(0.7),TSLA(1.5)")
-- Password: Finnhub API-Key

-- MIT License

-- Original work Copyright (c) 2017 Jacubeit
-- Modified work Copyright 2020 tobiasdueser

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


WebBanking{
  version = 1.2,
  country = "de",
  description = "Include your stock portfolio in MoneyMoney by providing the stock symbols and the number of shares as username [Example: AAPL(0.3),SHOP(1.4)] and a free Finnhub API-Key as password.",
  services= { "StockPortfolio" }
}

local stockSymbols
local connection = Connection()
local currency = "EUR"
local finnhubToken

function SupportsBank (protocol, bankCode)
  return protocol == ProtocolWebBanking and bankCode == "StockPortfolio"
end

function InitializeSession (protocol, bankCode, username, username2, password, username3)
  stockSymbols = username:gsub("%s+", "")
  finnhubToken = password
end

function ListAccounts (knownAccounts)
  local account = {
    name = "StockPortfolio",
    accountNumber = "StockPortfolio",
    currency = currency,
    portfolio = true,
    type = "AccountTypePortfolio"
  }

  return {account}
end

function RefreshAccount (account, since)
  local s = {}
  -- get EUR -> USD exchange Rate
  EURtoUSDexchangeRate = requestCurrentExchangeRate()

  for stock in string.gmatch(stockSymbols, '([^,]+)') do

    -- Pattern: AAPL(0.3),SHOP(1.4)
    quantity=stock:match("%((%S+)%)")
    stockName=stock:match('([^(]+)')

    -- request current stock price and convert from USD to EUR
    currentStockPrice = requestCurrentStockPrice(stockName) / EURtoUSDexchangeRate

    s[#s+1] = {
      name = stockName,
      currency = nil,
      quantity = quantity,
      price = currentStockPrice,
    }

  end

  return {securities = s}
end

function EndSession ()
end


-- Query Functions
function requestCurrentStockPrice(stockSymbol)
  response = connection:request("GET", stockPriceRequestUrl(stockSymbol), {})
  json = JSON(response)
  return json:dictionary()["c"]
end

function requestCurrentExchangeRate()
  response = connection:request("GET", exchangeRateRequestUrl(), {})
  json = JSON(response)
  return json:dictionary()["eur"] ["inverseRate"]
end


-- Helper Functions
function stockPriceRequestUrl(stockSymbol)
  return "https://finnhub.io/api/v1/quote?symbol=" .. stockSymbol .. "&token=" .. finnhubToken
end

function exchangeRateRequestUrl()
  return "https://www.floatrates.com/daily/usd.json"
end

