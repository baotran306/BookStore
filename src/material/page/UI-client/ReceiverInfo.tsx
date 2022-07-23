import React, { useState, useEffect } from "react";
import Axios from '../../Axios';
import { Container } from "react-bootstrap";
import './style/ReceiverInfo.css';
import {
    TextField
    , Button
} from "@mui/material";
import { useLocation, useNavigate } from "react-router-dom";

const ReceiverInfo = () => {
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
        localStorage.setItem('receiver', JSON.stringify(customer));
        navigate('/cart');
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
                                <div className="bottom">
                                    <TextField label={'Họ người nhận*'} className={'form-control'}
                                        name={"last_name"}
                                        value={`${customer.last_name}`}
                                        onChange={handleChange} />
                                </div>
                            </div>
                            <div className="container-input">
                                <div className="bottom">
                                    <TextField label={'Tên người nhận*'}
                                        className={'form-control'}
                                        name={"first_name"}
                                        onChange={handleChange}
                                        value={`${customer.first_name}`} />
                                </div>
                            </div>
                            <div className="container-input">
                                <div className="bottom">
                                    <TextField label={'Địa chỉ người nhận*'}
                                        onChange={handleChange}
                                        name={"address"}
                                        className={'form-control'}
                                        value={`${customer.address}`} />
                                </div>
                            </div>
                            <div className="container-input">
                                <div className="bottom">
                                    <TextField label={'Số điện thoại người nhận*'}
                                        className={'form-control'}
                                        name={"phone_number"}
                                        onChange={handleChange}
                                        value={`${customer.phone_number}`} />
                                </div>
                            </div>
                            <div className="container-input">
                                <div className="bottom">
                                    <TextField label={'Email người nhận *'}
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