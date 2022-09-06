import React, { useState, useEffect } from "react";
import Axios from '../../Axios';
import { Container } from "react-bootstrap";
import './style/ReceiverInfo.css';
import {
    TextField
    , Button
    , FormControl
    , FormHelperText

} from "@mui/material";
import { useLocation, useNavigate } from "react-router-dom";

const ReceiverInfo = () => {
    const initialError = {
        first_name: false,
        last_name: false,
        address: false,
        phone_number: false,
        mail: false
    }
    const initialMessageError = {
        first_name: '',
        last_name: '',
        address: '',
        phone_number: '',
        mail: ''
    }
    const [error, setError] = useState(initialError);
    const [messageError, setMessageError] = useState(initialMessageError);

    const receiver = { first_name: '', last_name: '', address: '', phone_number: '', email: '' };
    const [customer, setCustomerInfo] = useState(receiver);
    const location = useLocation();
    const navigate = useNavigate();
    const getCustomerInfo = () => {
        if (localStorage.getItem('receiver')) {
            let temp = JSON.parse(localStorage.getItem('receiver')!);
            setCustomerInfo(temp);
        } else if (localStorage.getItem('accessToken')) {
            let temp = JSON.parse(localStorage.getItem('accessToken')!);
            setCustomerInfo(temp);
        }
    }

    useEffect(() => {
        getCustomerInfo();

    }, []);
    const handleChange = (event: any) => {
        console.log(event.target);
        setCustomerInfo({ ...customer, [event.target.name]: event.target.value })
    }
    const handleSave = () => {
        if (!valid()) {
            localStorage.setItem('receiver', JSON.stringify(customer));
            navigate('/cart');
        }
    }
    const valid = () => {
        let flag = false;
        let error = initialError;
        let messageError = initialMessageError;

        if (customer.first_name === undefined || customer.first_name === '') {
            error.first_name = true;
            messageError.first_name = 'Chưa nhập tên';
            flag = true;
        } else {
            error.first_name = false;
            messageError.first_name = '';
        }

        if (customer.last_name === undefined || customer.last_name === '') {
            error.last_name = true;
            messageError.last_name = 'Chưa nhập họ';
            flag = true;
        } else {
            error.last_name = false;
            messageError.last_name = '';
        }

        if (customer.phone_number === undefined || customer.phone_number === '') {
            error.phone_number = true;
            messageError.phone_number = 'Chưa nhập số điện thoại';
            flag = true;
        } else {
            error.phone_number = false;
            messageError.phone_number = '';
        }

        if (customer.address === undefined || customer.address === '') {
            error.address = true;
            messageError.address = 'Chưa nhập địa chỉ';
            flag = true;
        } else {
            error.address = false;
            messageError.address = '';
        }
        setError(error);
        setMessageError(messageError);
        return flag;
    }
    return (
        <Container>
            <div className="container">
                <div className="updateClothesContainer">
                    <div className="header">
                        <h4>
                            Chỉnh sửa thông tin người nhận
                        </h4>
                        <hr />
                    </div>
                    <div className="main">
                        <div className="left">
                            <div className="container-input">
                                <TextField label={'Họ người nhận*'} className={'form-control'}
                                    name={"last_name"}
                                    value={`${customer.last_name}`}
                                    error={error.last_name}
                                    onChange={handleChange} />
                                {error.last_name && <FormControl error variant="standard">
                                    <FormHelperText id="component-error-text">{messageError.last_name}</FormHelperText>
                                </FormControl>}
                            </div>
                            <div className="container-input">
                                <TextField label={'Tên người nhận*'}
                                    className={'form-control'}
                                    name={"first_name"}
                                    onChange={handleChange}
                                    error={error.first_name}
                                    value={`${customer.first_name}`} />
                                {error.first_name && <FormControl error variant="standard">
                                    <FormHelperText id="component-error-text">{messageError.first_name}</FormHelperText>
                                </FormControl>}
                            </div>
                            <div className="container-input">
                                <TextField label={'Địa chỉ người nhận*'}
                                    onChange={handleChange}
                                    name={"address"}
                                    className={'form-control'}
                                    error={error.address}
                                    value={`${customer.address}`} />
                                {error.address && <FormControl error variant="standard">
                                    <FormHelperText id="component-error-text">{messageError.address}</FormHelperText>
                                </FormControl>}
                            </div>
                            <div className="container-input">
                                <TextField label={'Số điện thoại người nhận*'}
                                    className={'form-control'}
                                    name={"phone_number"}
                                    onChange={handleChange}
                                    error={error.phone_number}
                                    value={`${customer.phone_number}`} />
                                {error.phone_number && <FormControl error variant="standard">
                                    <FormHelperText id="component-error-text">{messageError.phone_number}</FormHelperText>
                                </FormControl>}
                            </div>
                            <div className="container-input">
                                <div className="bottom">
                                    <TextField label={'Email người nhận '}
                                        onChange={handleChange}
                                        className={'form-control'}
                                        name={"email"}
                                        value={`${customer.email}`} />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="btnContainer">
                        <Button onClick={handleSave} sx={{ width: '100px' }} variant="outlined">Save</Button>
                    </div>
                </div>
            </div>
        </Container>
    )
}

export default ReceiverInfo;