import { Route, Routes } from 'react-router-dom';
import ChatbotPage from '../pages/ChatbotPage';

const ChatbotRoutes = () => {
    return (
        <Routes>
            <Route path="/" element={<ChatbotPage />} />
        </Routes>
    );
};

export default ChatbotRoutes;
