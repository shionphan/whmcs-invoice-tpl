<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="https://github.com/shionphan" />
    <title>{$companyname} - {* This code should be uncommented for EU companies using the sequential invoice numbering so that when unpaid it is shown as a proforma invoice {if $status eq "Paid"}*}{$LANG.invoicenumber}{*{else}{$LANG.proformainvoicenumber}{/if}*}{$invoicenum}</title>
    <link rel="shortcut icon" href="templates/{$template}/favicon.ico" type="image/x-icon" />
    <link href="//cdn.bootcss.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">
    <link href="templates/{$template}/css/invoice.css?v={$versionHash}" rel="stylesheet">
</head>

<body>
<div class="container">
    {if $error}
    <div class="alert alert-danger">{$LANG.invoiceserror}</div>
    {else}
    <div class="inv-cont">
        <div class="row">
            <div class="col-sm-7">
                <h1>{if $logo}<p><img class="invoice-logo" src="{$logo}" width="200" title="{$companyname}" /></p>{else}<h1>{$companyname}</h1>{/if}</h1>
                <div class="inv-invnum">
                    <div class="row">
                        <div class="col-sm-6">
                            <h2>{$LANG.firstpaymentamount}</h2>
                            <p class="inv-paymon">{$total}</p>
                        </div>
                        <div class="col-sm-6">
                            <h2>{* This code should be uncommented for EU companies using the sequential invoice numbering so that when unpaid it is shown as a proforma invoice {if $status eq "Paid"}*}{$LANG.invoicenumber}{*{else}{$LANG.proformainvoicenumber}{/if}*}{$invoicenum}</h2>
                            <p>{$LANG.invoicesdatecreated}: {$datecreated}<br />{$LANG.invoicesdatedue}: {$datedue}</p>
                        </div>
                    </div>
                </div>
                <div class="inv-company">
                    <h2>{$LANG.invoicespayto}</h2>
                    <p>{$payto}</p>
                </div>
                <div class="inv-paycom">
                    <h2>{$LANG.invoicesinvoicedto}</h2>
                    <p>
                        {if $clientsdetails.companyname}{$clientsdetails.companyname}<br />{/if}
                        {$clientsdetails.firstname} {$clientsdetails.lastname}<br />
                        {$clientsdetails.address1}, {$clientsdetails.address2}<br />
                        {$clientsdetails.country} {$clientsdetails.state} {$clientsdetails.city} {$clientsdetails.postcode}
                        {if $customfields}
                        {foreach from=$customfields item=customfield}
                        {$customfield.fieldname}: {$customfield.value}<br />
                        {/foreach}
                        {/if}
                    </p>
                </div>
            </div>
            <div class="col-sm-5">
                <div class="inv-payment text-center">
                    {if $status eq "Unpaid"}
                        <div class="inv-paystatus unpaid">{$LANG.invoicesunpaid}</div>
                        {if $allowchangegateway}
                            <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}">{$gatewaydropdown}</form>
                        {else}
                            <div class="inv-paymathod">{$paymentmethod}</div>
                        {/if}
                        <div class="inv-paymathod">{$paymentbutton}</div>
                    {elseif $status eq "Paid"}
                        <div class="inv-paystatus paid">{$LANG.invoicespaid}</div>
                        <div class="inv-paymathod">{$paymentmethod}</div>
                        <p>({$datepaid})</p>
                    {elseif $status eq "Refunded"}
                        <div class="inv-paystatus refunded">{$LANG.invoicesrefunded}</div>
                    {elseif $status eq "Cancelled"}
                        <div class="inv-paystatus cancelled">{$LANG.invoicescancelled}</div>
                    {elseif $status eq "Collections"}
                        <div class="inv-paystatus collections">{$LANG.invoicescollections}</div>
                    {/if}

                    {if $smarty.get.paymentsuccess}
                        <div class="inv-paystatus paid">{$LANG.invoicepaymentsuccessconfirmation}</div>
                    {elseif $smarty.get.pendingreview}
                        <div class="inv-paystatus paid">{$LANG.invoicepaymentpendingreview}</div>
                    {elseif $smarty.get.paymentfailed}
                        <div class="inv-paystatus unpaid">{$LANG.invoicepaymentfailedconfirmation}</div>
                    {elseif $offlinepaid}
                        <div class="inv-paystatus refunded">{$LANG.invoiceofflinepaid}</div>
                    {/if}

                    {if $manualapplycredit}
                        <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}">
                            <input type="hidden" name="applycredit" value="true" />
                            <div class="creditbox">
                            {$LANG.invoiceaddcreditdesc1} {$totalcredit}. {$LANG.invoiceaddcreditdesc2}<br />
                            {$LANG.invoiceaddcreditamount}: <input type="text" name="creditamount" size="10" value="{$creditamount}" /> <input type="submit" value="{$LANG.invoiceaddcreditapply}" />
                            </div>
                        </form>
                    {/if}
                </div>
            </div>
        </div>
        <div class="panel panel-info">
            <div class="panel-heading">
                <div class="panel-title"><h2>{$LANG.invoicestransamount}</h2></div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped table-bordered">
                    <thead>
                        <tr class="tr-success">
                            <td width="80%">{$LANG.invoicesdescription}</td>
                            <td width="20%">{$LANG.invoicesamount}</td>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$invoiceitems item=item}
                        <tr>
                            <td>{$item.description}{if $item.taxed eq "true"} *{/if}</td>
                            <td class="textcenter">{$item.amount}</td>
                        </tr>
                        {/foreach}
                        <tr class="title">
                            <td class="textright">{$LANG.invoicessubtotal}:</td>
                            <td class="textcenter">{$subtotal}</td>
                        </tr>
                        {if $taxrate}
                        <tr class="title">
                            <td class="textright">{$taxrate}% {$taxname}:</td>
                            <td class="textcenter">{$tax}</td>
                        </tr>
                        {/if}
                        {if $taxrate2}
                        <tr class="title">
                            <td class="textright">{$taxrate2}% {$taxname2}:</td>
                            <td class="textcenter">{$tax2}</td>
                        </tr>
                        {/if}
                        <tr class="title">
                            <td class="textright">{$LANG.invoicescredit}:</td>
                            <td class="textcenter">{$credit}</td>
                        </tr>
                        <tr class="title">
                            <td class="textright">{$LANG.invoicestotal}:</td>
                            <td class="textcenter">{$total}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            {if $taxrate}
            <div class="panel-body">
            * {$LANG.invoicestaxindicator}
            </div>
            {/if}
            <div class="panel-heading">
                <div class="panel-title"><h2>{$LANG.invoicestransactions}</h2></div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped table-bordered">
                    <thead>
                        <tr class="title textcenter">
                            <td width="30%">{$LANG.invoicestransdate}</td>
                            <td width="25%">{$LANG.invoicestransgateway}</td>
                            <td width="25%">{$LANG.invoicestransid}</td>
                            <td width="20%">{$LANG.invoicestransamount}</td>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$transactions item=transaction}
                        <tr>
                            <td class="textcenter">{$transaction.date}</td>
                            <td class="textcenter">{$transaction.gateway}</td>
                            <td class="textcenter">{$transaction.transid}</td>
                            <td class="textcenter">{$transaction.amount}</td>
                        </tr>
                        {foreachelse}
                        <tr>
                            <td class="textcenter" colspan="4">{$LANG.invoicestransnonefound}</td>
                        </tr>
                        {/foreach}
                        <tr class="title">
                            <td class="textright" colspan="3">{$LANG.invoicesbalance}:</td>
                            <td class="textcenter">{$balance}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            {if $notes}
            <div class="panel-body">
                {$LANG.invoicesnotes}: {$notes}
            </div>
            {/if}
        </div>
        <div class="text-center"><div class="btn-group text-center"><a href="clientarea.php" class="btn btn-warning">{$LANG.invoicesbacktoclientarea}</a><a href="javascript:window.close()" class="btn btn-danger">{$LANG.closewindow}</a></div></div>
    </div>
    {/if}
</div>
</body>
</html>