import * as React from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import Slide from '@mui/material/Slide';
import { TransitionProps } from '@mui/material/transitions';
import Login from './Login';
import Axios from '../../../Axios';

const Transition = React.forwardRef(function Transition(
    props: TransitionProps & {
        children: React.ReactElement<any, any>;
    },
    ref: React.Ref<unknown>,
) {
    return <Slide direction="up" ref={ref} {...props} />;
});

export default function LoginDialog(props: any) {
    const userTP = { username: '', password: '' };
    const [user, setUser] = React.useState(userTP);
    const [userMessageError, setUserMessageError] = React.useState('');
    const handleClose = () => {
        props.setOpen(false);
    };
    const loginApi = () => {
        Axios.post('customer/login', {
            account: user.username,
            password: user.password,
        }).then((res) => {
            localStorage.setItem("accessToken", JSON.stringify(res.data.info[0]));
            props.setAccessToken(localStorage.getItem('accessToken'));
            props.setOpen(false);
        }).catch((error) => {
            setUserMessageError(error.response.data.message);
        })
    }
    const handleClick = () => {
        if (!valid()) {
            loginApi();
        }
        // alert(JSON.stringify(user));
    }
    const valid = () => {
        let flagError = false;
        if (user.username === '' || user.password === '') {
            flagError = true;
            setUserMessageError('Chưa nhập tên đăng nhập hoặc mật khảu!')
        }
        if (!flagError) {
            setUserMessageError('');
        }
        return flagError;
    }
    return (
        <div>
            <Dialog
                open={props.open}
                TransitionComponent={Transition}
                keepMounted
                onClose={handleClose}
                aria-describedby="alert-dialog-slide-description"

            >
                <DialogTitle style={{ textAlign: 'center', fontWeight: 'bold' }}>{props.title}</DialogTitle>
                <DialogContent>
                    <DialogContentText id="alert-dialog-slide-description">
                        <Login handleClick={handleClick} setUser={setUser}
                            user={user}
                            userMessageError={userMessageError} setUserMessageError={setUserMessageError} />
                    </DialogContentText>
                </DialogContent>
                <DialogActions style={{ display: 'flex', justifyContent: 'center', height: '90px' }}>
                    <Button style={{ width: '80%', padding: '10px 0 10px 0' }} variant="contained" onClick={handleClick}>Đăng nhập</Button>
                </DialogActions>
            </Dialog>
        </div>
    );
}
