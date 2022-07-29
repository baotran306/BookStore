import React, { useState, useEffect } from 'react';
import Box from '@mui/material/Box';
import { Tab, Tabs, Typography } from "@mui/material";
import './DeliveryState.css';
import DeliveryItem from './DeliveryItem';
import Axios from '../../../Axios';
interface TabPanelProps {
    children?: React.ReactNode;
    index: number;
    value: number;
}

function TabPanel(props: TabPanelProps) {
    const { children, value, index, ...other } = props;

    return (
        <div
            role="tabpanel"
            hidden={value !== index}
            id={`simple-tabpanel-${index}`}
            aria-labelledby={`simple-tab-${index}`}
            {...other}
        >
            {value === index && (
                <Box sx={{ p: 3 }}>
                    <Typography>{children}</Typography>
                </Box>
            )}
        </div>
    );
}

export default function CenteredTabs() {
    const [value, setValue] = useState(sessionStorage.getItem('valueTabOrder') ? parseInt(sessionStorage.getItem('valueTabOrder')!) : 0);
    const bill = {
        receiver_info: {
            "address": "",
            "cart_id": 0,
            "email": "",
            "first_name": "",
            "last_name": "",
            "order_cart_time": "",
            "phone_number": "",
            "status_id": 0,
            "status_name": ""
        },
        list_item: [
            {
                "book_name": "",
                "cart_id": 0,
                "image": "",
                "isbn": "",
                "price": "",
                "quantity": 0
            }
        ],
        total: 0
    }
    const [bills, setBills] = useState([bill])
    useEffect(() => {
        const user = localStorage.getItem('accessToken')! as any;
        Axios.get(`customer/get-history-order/${JSON.parse(user).customer_id}`)
            .then(res => {
                let billTemp = res.data;
                setBills(billTemp);
            }).catch(error => {
                console.log(error);
            })
    }, [])
    const handleChange = (event: React.SyntheticEvent, newValue: number) => {
        setValue(newValue);
        sessionStorage.setItem('valueTabOrder', newValue.toString());
    };

    return (
        <div className='container-delivery'>
            <div className='container-delivery-status'>
                <div className='tablist'>
                    <Tabs className='tabs-delivery' sx={{ width: '100%' }} value={value} onChange={handleChange} centered>
                        <Tab sx={{ width: '20%' }} label="All" />
                        <Tab sx={{ width: '20%' }} label="Processing" />
                        <Tab sx={{ width: '20%' }} label="Delivering" />
                        <Tab sx={{ width: '20%' }} label="Finishing" />
                        <Tab sx={{ width: '20%' }} label="Canceling" />
                    </Tabs>
                </div>
                <div className='tab-details'>
                    <TabPanel value={value} index={0}>
                        {bills.map((item) => <DeliveryItem item={item} />)}
                    </TabPanel>
                    <TabPanel value={value} index={1}>
                        {bills.map((item) => item.receiver_info.status_id === 1 ? <DeliveryItem item={item} /> : <></>)}
                    </TabPanel>
                    <TabPanel value={value} index={2}>
                        {bills.map((item) => item.receiver_info.status_id === 2 ? <DeliveryItem item={item} /> : <></>)}
                    </TabPanel>
                    <TabPanel value={value} index={3}>
                        {bills.map((item) => item.receiver_info.status_id === 3 ? <DeliveryItem item={item} /> : <></>)}
                    </TabPanel>
                    <TabPanel value={value} index={4}>
                        {bills.map((item) => item.receiver_info.status_id === 4 ? <DeliveryItem item={item} /> : <></>)}
                    </TabPanel>
                </div>
            </div>
        </div>
    );
}
