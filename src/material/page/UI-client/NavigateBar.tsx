import React, { useState } from "react";
import { Nav } from "react-bootstrap";
import { FaSearch, FaUser, FaShoppingCart } from 'react-icons/fa'
import { useNavigate } from "react-router-dom";
import { ExpandMore, Search } from '@mui/icons-material'
import { Row, Col, Container, Form } from 'react-bootstrap'
import { Link } from "react-router-dom";
import './style/Navigate.css'
import LoginDialog from './login/LoginDialog'
import { Avatar } from "@mui/material";
import DropDownUser from "./dropdown/DropDownUser";


const Navigate = (props: any) => {
    const redirect = useNavigate();
    const [showSearch, setShowSearch] = useState(false);
    const [showUser, setShowUser] = useState(false);
    const [valueSearch, setValueSearch] = useState('');
    const handleEnterPress = (e: any) => {
        if (e.key === 'Enter') {
            redirect(`search/${valueSearch.replace(/\s\s+/g, ' ').trim()}`);
        }
    }
    return (
        <div className="navbar-design">
            <Row>
                <Col xl={5}>
                    <Nav className="me-auto">
                        <Nav.Link style={{ paddingTop: '0px' }} as={Link} to={'/'}>TRANG CHỦ</Nav.Link>
                        <Nav.Link style={{ paddingTop: '0px' }} as={Link} to={'/error'}>THỂ LOẠI</Nav.Link>
                        <Nav.Link style={{ paddingTop: '0px' }} href="#pricing">TÁC GIẢ<ExpandMore /></Nav.Link>
                        <Nav.Link style={{ paddingTop: '0px' }} href="#pricing">LABEL <ExpandMore /></Nav.Link>
                    </Nav>
                </Col>
                <Col xl={3} style={{ position: 'relative' }}>
                    {showSearch ? (<input className="form-control"
                        style={{ position: 'absolute', left: '0', bottom: '5px', width: '330px' }}
                        onKeyDown={handleEnterPress}
                        value={valueSearch}
                        onChange={(text: any) => setValueSearch(text.target.value)}
                        placeholder={"Tìm sách ..."} />) : <></>}
                </Col>
                <Col xl={4}>
                    <Nav className="me-auto">
                        <Nav.Link style={{ paddingTop: '0px' }} onClick={() => {
                            if (showSearch === false) {
                                setShowSearch(true)
                            } else {
                                setShowSearch(false)
                            }
                        }} title='search'>
                            <Search />
                        </Nav.Link>
                        <Nav.Link style={{ paddingTop: '0px' }} onClick={() => redirect('/cart')}>
                            <div className="containerCart">
                                <FaShoppingCart />
                                {props.size > 0 ?
                                    <div className="iconCount">
                                        <span>{props.size}</span>
                                    </div> : <></>}
                            </div>
                        </Nav.Link>
                        {props.accessToken === null ?
                            <Nav.Link style={{ paddingTop: '0px' }} onClick={() => { setShowUser(true) }}><FaUser /></Nav.Link>
                            : <Nav.Link style={{ position: 'absolute', right: '60px', top: '-15px' }}><DropDownUser setAccessToken={props.setAccessToken} /></Nav.Link>}
                        <LoginDialog open={showUser} setOpen={setShowUser} title={'Login'} setAccessToken={props.setAccessToken} />
                    </Nav>
                </Col>
            </Row>
        </div>
    )
}

export default Navigate;