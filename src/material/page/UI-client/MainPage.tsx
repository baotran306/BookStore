import React from 'react';
import { Col, Container, Row } from 'react-bootstrap';
import { BrowserRouter, Route, Router, Routes } from 'react-router-dom';
import Error from './Error';
import NavigateHeader from './Header';
import ScreenCard from './ScreenShowCard';
import SearchScreen from './SearchScreen';

const MainPage = () => {
    return (
        <div className="main">
            <div>
                <NavigateHeader />
            </div>
            <Container fluid style={{ paddingTop: '80px' }}>
                <Row>
                    <Routes>
                        <Route path='/shop/:tag_label/:tag' element={<Error />} />
                        <Route path='/search/:bookName' element={<SearchScreen />} />
                        <Route path='/' element={<ScreenCard />} />
                    </Routes>
                </Row>
            </Container>
        </div>)
}

export default MainPage;