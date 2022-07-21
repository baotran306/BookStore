import * as React from 'react';
import Button from '@mui/material/Button';
import { styled } from '@mui/material/styles';
import Dialog from '@mui/material/Dialog';
import DialogTitle from '@mui/material/DialogTitle';
import DialogContent from '@mui/material/DialogContent';
import DialogActions from '@mui/material/DialogActions';
import IconButton from '@mui/material/IconButton';
import CloseIcon from '@mui/icons-material/Close';
import Typography from '@mui/material/Typography';
import { Row, Col } from 'react-bootstrap';
import './style/DialogCustomerAdd.css';

const BootstrapDialog = styled(Dialog)(({ theme }) => ({
    '& .MuiDialogContent-root': {
        padding: theme.spacing(2),
    },
    '& .MuiDialogActions-root': {
        padding: theme.spacing(1),
    },
}));

export interface DialogTitleProps {
    id: string;
    children?: React.ReactNode;
    onClose: () => void;
}

const BootstrapDialogTitle = (props: DialogTitleProps) => {
    const { children, onClose, ...other } = props;

    return (
        <DialogTitle sx={{ m: 0, p: 2 }} {...other}>
            {children}
            {onClose ? (
                <IconButton
                    aria-label="close"
                    onClick={onClose}
                    sx={{
                        position: 'absolute',
                        right: 8,
                        top: 8,
                        color: (theme) => theme.palette.grey[500],
                    }}
                >
                    <CloseIcon />
                </IconButton>
            ) : null}
        </DialogTitle>
    );
};

export default function CustomizedDialogs(props: any) {
    const handleClose = () => {
        props.setOpen(false);
    };
    const handleAdd = () => {
        props.shoppingCart.afterDiscountPrice = parseInt(props.price_discount ? props.price_discount : props.price_current);
        props.shoppingCart.beforeDiscountPrice = parseFloat(props.price_current);
        props.shoppingCart.name = props.title;
        props.shoppingCart.isbn = props.isbn;
        props.shoppingCart.img = props.img;
        props.handleClick(props.shoppingCart);
        props.setOpen(false);
    }

    return (
        <div>
            <BootstrapDialog
                onClose={handleClose}
                aria-labelledby="customized-dialog-title"
                open={props.open}
            >
                <BootstrapDialogTitle id="customized-dialog-title" onClose={handleClose}>
                    <Row><span className='title'>{props.title}</span></Row>
                    <Row>
                        <Col>
                            <span className='price'>
                                {new Intl.NumberFormat().format(props.price_discount ? props.price_discount : props.price_current)}
                            </span>
                            {props.price_discount ? <span className='priceDiscount'>
                                {new Intl.NumberFormat().format(props.price_current)}
                            </span> : null}
                        </Col>
                    </Row>
                </BootstrapDialogTitle>
                <DialogContent dividers>
                    <Typography gutterBottom>
                        {props.children}
                    </Typography>
                </DialogContent>
                <DialogActions style={{ justifyContent: 'center' }}>
                    <Button id='btn-add' style={{ width: '80%' }} autoFocus onClick={handleAdd}>
                        ADD
                    </Button>
                </DialogActions>
            </BootstrapDialog>
        </div >
    );
}
