import * as React from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import { useNavigate } from "react-router-dom";
import DialogTitle from '@mui/material/DialogTitle';
import useMediaQuery from '@mui/material/useMediaQuery';
import { useTheme } from '@mui/material/styles';
import { PayPalButtons, PayPalScriptProvider } from "@paypal/react-paypal-js";

export default function DialogPayMent(props: any) {
    const theme = useTheme();
    const [paidFor, setPaidFor] = React.useState(false);
    const [error, setError] = React.useState(null);
    const redirect = useNavigate();

    const handleApprove = (orderId: any) => {
        setPaidFor(true);
    }

    if (paidFor) {
        alert("Thank You for purchasing from Eazy2Code");
    }

    if (error) {
        alert(error);
    }
    const handleClose = () => {
        props.setOpen(false);
    };
    const handlApprove = (data: any) => {

    }

    return (
        <div>
            <Dialog
                open={props.open}
                onClose={handleClose}
                aria-labelledby="responsive-dialog-title"
            >
                <DialogTitle id="responsive-dialog-title" style={{ textAlign: 'center', fontWeight: '600' }}>
                    {"PAYMENT"}
                </DialogTitle>
                <DialogContent>
                    <DialogContentText>
                        <PayPalScriptProvider options={{
                            "client-id": "AbHXLZ77N0PJo1CAspFIU157G1n8KFF7V-ZlIEgKCAM_IcMnL1zMjLXHtIBVp8Rpinyth5URxONj-LHx",
                        }}>
                            <PayPalButtons
                                createOrder={(data: any, actions: any) => {
                                    return actions.order.create({
                                        intent: "CAPTURE",
                                        purchase_units: [
                                            {
                                                description: "Cool looking table",
                                                amount: {
                                                    currency_code: "USD",
                                                    value: props.totalPay,
                                                },
                                            },
                                        ],
                                    })
                                }}
                                onApprove={async (data: any, actions: any) => {
                                    props.setCheckOut(true)
                                    const order = await actions.order.capture();
                                    console.log(order);
                                    redirect(`/`);
                                    alert('Đặt hàng thành công');
                                }}
                                onCancel={() => { }}
                                onError={(err: any) => {
                                    setError(err);
                                    console.log("PayPal Checkout onError", err);
                                }} />
                        </PayPalScriptProvider>
                    </DialogContentText>
                </DialogContent>
            </Dialog>
        </div>
    );
}
