import { Routes, Route, BrowserRouter as Router } from "react-router-dom";
import AuthProvider from "./AuthProvider";
import ProductsManagement from "./pages/ProductsManagement";
import NewProduct from "./pages/NewProduct";
import SellerDetail from "./pages/SellerDetail";
import UsersManagement from "./pages/UsersManagement";


function App() {
  return (
    <Router
      future={{
        v7_startTransition: true,
        v7_relativeSplatPath: true,
      }}
    >
      <AuthProvider >
        <Routes>
          <Route path="/" element={<ProductsManagement />} />
          <Route path="/product-new" element={<NewProduct />} />
          {/* <Route path="/admin//product-update" element={<ProductUpdate />} /> */}
          <Route path="/seller-detail/:sellerID" element={<SellerDetail />} />
          <Route path="/seller-management" element={<UsersManagement />} />
        </Routes>
      </AuthProvider>
    </Router>
  );
}

export default App;
