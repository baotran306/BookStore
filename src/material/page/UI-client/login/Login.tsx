import { TextField, FormControl, FormHelperText, InputLabel } from "@mui/material";
import React, { useEffect, useState } from "react";
import { Visibility, VisibilityOff } from '@mui/icons-material';
import './Login.css'
const Login = (props: any) => {
    const [hiddenPassword, setHiddenPassword] = useState(true);
    const handleChange = (value: any) => {
        props.setUser({ ...props.user, [value.target.name]: value.target.value.trim() });
    }
    const handleClickHidden = () => {
        setHiddenPassword(!hiddenPassword);
    }
    return (
        <div className="container">
            <div className="login-wrapper">
                <div className="username">
                    <FormControl error variant="standard" >
                        <TextField label={"username"}
                            name={'username'}
                            value={props.user.username}
                            error={props.userMessageError !== '' ? true : false}
                            onChange={handleChange} />
                    </FormControl>
                </div>
                <div className="password">
                    <TextField label={'password'}
                        error={props.userMessageError !== '' ? true : false}
                        type={hiddenPassword ? 'password' : 'text'}
                        name={'password'} value={props.user.password} onChange={handleChange} />
                    {hiddenPassword ? <Visibility className="icon-password" onClick={handleClickHidden} />
                        : <VisibilityOff className="icon-password" onClick={handleClickHidden} />}
                </div>
                <div>
                    <FormControl error variant="standard">
                        <FormHelperText id="component-error-text">{props.userMessageError}</FormHelperText>
                    </FormControl>
                </div>
                <div className="bottom-login">
                    <div><span onClick={() => { props.setOpen(false) }}>Forget password</span></div>
                    <div><span>Don't have an account?</span></div>
                </div>
            </div>
        </div>
    )
}
export default Login;