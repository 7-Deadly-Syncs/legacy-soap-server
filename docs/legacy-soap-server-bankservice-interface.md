# Legacy SOAP Server — BankService Interface

This document reflects the operations exposed by `axis2/services/BankService/services.xml` and the `BankService` dispatcher class in the repository. The service exposes these operations: `balance`, `register`, `deposit`, `getBankDetails`, `transfer`, `login`, `logout`, `getAccountProfile`, `qris`, and `getQrisMerchant`. There is no `withdraw` operation in the current service descriptor or dispatcher, so `withdraw` is documented here only as a deprecated placeholder.

## Common SOAP envelope

All requests and responses use the standard SOAP envelope with the `BankService.services.axis2` namespace and a single string return value in `<ns:return>`.

Axis2 RPC requests use positional arguments in method order:

```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:operationName>
         <ns:args0>...</ns:args0>
         <ns:args1>...</ns:args1>
         <ns:args2>...</ns:args2>
      </ns:operationName>
   </soapenv:Body>

</soapenv:Envelope>
```

```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:operationNameResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>...</ns:return>
    </ns:operationNameResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

## Operations

### balance
Checks the balance for an account using the account number and PIN.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:balance>
         <ns:args0>2623860486223779</ns:args0>
         <ns:args1>123456</ns:args1>
      </ns:balance>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:balanceResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|2623860486223779|2513523425431732|2500</ns:return>
    </ns:balanceResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

### register
Creates a new customer account.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:register>
         <ns:args0>John Doe</ns:args0>
         <ns:args1>john@example.com</ns:args1>
         <ns:args2>secret</ns:args2>
         <ns:args3>123456</ns:args3>
      </ns:register>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:registerResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|2623860486223779|2513523425431732</ns:return>
    </ns:registerResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

### deposit
Deposits funds into an account using the account number, PIN, and amount.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:deposit>
         <ns:args0>2623860486223779</ns:args0>
         <ns:args1>123456</ns:args1>
         <ns:args2>2500</ns:args2>
      </ns:deposit>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:depositResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|2623860486223779|2500</ns:return>
    </ns:depositResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

### getBankDetails
Returns bank-level account details based on email and password.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:getBankDetails>
         <ns:args0>john@example.com</ns:args0>
         <ns:args1>secret</ns:args1>
      </ns:getBankDetails>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:getBankDetailsResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|BANK|0001|Legacy Bank</ns:return>
    </ns:getBankDetailsResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

### transfer
Transfers funds from one account to another.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:transfer>
         <ns:args0>2623860486223779</ns:args0>
         <ns:args1>12345</ns:args1>
         <ns:args2>2513523425431732</ns:args2>
         <ns:args3>2500</ns:args3>
      </ns:transfer>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:transferResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|2623860486223779|2513523425431732|2500</ns:return>
    </ns:transferResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

### login
Authenticates a user and returns a session id plus expiry when the backend succeeds.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:login>
         <ns:args0>john@example.com</ns:args0>
         <ns:args1>secret</ns:args1>
      </ns:login>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:loginResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|CUST123|2623860486223779|John Doe|SESS-0123456789ABCDEF0123456789ABCDEF|1718097600</ns:return>
    </ns:loginResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

### logout
Invalidates a session.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:logout>
         <ns:args0>SESS-0123456789ABCDEF0123456789ABCDEF</ns:args0>
      </ns:logout>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:logoutResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|LOGOUT</ns:return>
    </ns:logoutResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

### getAccountProfile
Returns the profile data for an account.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:getAccountProfile>
         <ns:args0>2623860486223779</ns:args0>
         <ns:args1>secret</ns:args1>
      </ns:getAccountProfile>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:getAccountProfileResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|2623860486223779|John Doe|john@example.com</ns:return>
    </ns:getAccountProfileResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

### qris
Processes a QRIS payment using account, merchant, and amount.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:qris>
         <ns:args0>2623860486223779</ns:args0>
         <ns:args1>MERCHANT001</ns:args1>
         <ns:args2>2500</ns:args2>
      </ns:qris>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:qrisResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|2623860486223779|MERCHANT001|2500</ns:return>
    </ns:qrisResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

### getQrisMerchant
Returns merchant details for a QRIS merchant id.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:getQrisMerchant>
         <ns:args0>MERCHANT001</ns:args0>
      </ns:getQrisMerchant>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:getQrisMerchantResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>OK|MERCHANT001|Legacy Shop</ns:return>
    </ns:getQrisMerchantResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

## Deprecated

### withdraw
This operation is not exposed by the current Axis2 service descriptor or dispatcher, but it is included here as a deprecated interface for compatibility.

Request:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns="http://BankService.services.axis2">

   <soapenv:Header/>

   <soapenv:Body>
      <ns:withdraw>
         <ns:args0>2623860486223779</ns:args0>
         <ns:args1>123456</ns:args1>
         <ns:args2>2500</ns:args2>
      </ns:withdraw>
   </soapenv:Body>

</soapenv:Envelope>
```

Response:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:withdrawResponse xmlns:ns="http://BankService.services.axis2">
      <ns:return>DEPRECATED|withdraw is not supported</ns:return>
    </ns:withdrawResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

## Notes

- The service class is `axis2.services.BankService.BankService`.
- Axis2 uses `RPCMessageReceiver` for every exposed operation.
- Most service methods return the backend string after trimming it.
- `login` is special: on success it returns a generated session id and expiry timestamp.
- `getBankDetails` and `getQrisMerchant` explicitly return `ERROR: ...` on exception.
- `balance` now authenticates the account using the stored transaction PIN hash, which aligns with the current DANTE balance integration. `transfer` already uses the transaction PIN, while `qris` only checks account existence and funds.
