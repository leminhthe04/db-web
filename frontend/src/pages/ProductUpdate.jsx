import { useState, useEffect } from "react";
import Header from "../components/Header";
import Footer from "../components/Footer";
import axios from "axios";
import { useNavigate, useParams } from "react-router-dom";

export default function ProductUpdate() {
    const { productID } = useParams();
    console.log(productID);
    // alert(id);
    const navigate = useNavigate();
    // IMAGE

    // PRODUCT VALUE
    const [catList, setCatList] = useState([]);
    const [name, setname] = useState(null);
    const [store_name, setstore_name] = useState(null);
    const [seller_name, setseller_name] = useState(null);
    const [brand, setBrand] = useState(null);
    const [selectCat, setSelectCat] = useState(null);
    const [description, setDiscription] = useState(null);
    const [price, setPrice] = useState(null);
    const [category, setCategory] = useState(null);
    const [categoryName, setCategoryName] = useState(null);
    const [quantity, setQuantity] = useState(null);
    const [status, setStatus] = useState(null);

    // FUNCTION
    // useEffect(async () => {
    //     // Sử dụng Promise.all để gọi nhiều request đồng thời
    //     // Promise.all([
    //     //     axios.get(`http://localhost:8000/api/product/get-detail/${id}`),
    
    //     // ])
    //         axios.get(`http://localhost/api/product/detail/${productID}`)
    //             .then((response) => {
    //             const prodDetail = response.data.data[0];
    //             console.log("Check product detail: ", prodDetail);
    //             // Set thông tin sản phẩm
    //             setname(prodDetail.name);
    //             // setstore_name(prodDetail.store_name);
    //             // setseller_name(prodDetail.seller_name);
    //             setBrand(prodDetail.brand);
    //             setDiscription(prodDetail.description);
    //             setPrice(prodDetail.price);
    //             setCategory(prodDetail.category);
    //             setQuantity(prodDetail.quantity);
    //             setStatus(prodDetail.status);
                 
    //             const sellerData = await axios.get(`http://localhost/api/seller/detail/${prodDetail.seller_id}`);
    //         })
    //         .catch((error) => {
    //             console.error('Error fetching data:', error);
    //         });
    // }, []);

    useEffect(() => {
        const fetchData = async () => {
          try {
            // Lấy chi tiết sản phẩm
            const productResponse = await axios.get(`http://localhost/api/product/detail/${productID}`);
            const prodDetail = productResponse.data.data[0];
            console.log("Check product detail: ", prodDetail);
      
            // Set thông tin sản phẩm
            setname(prodDetail.product_name);
            setBrand(prodDetail.brand);
            setDiscription(prodDetail.description);
            setPrice(prodDetail.price);
            setCategory(prodDetail.category_id);
            setCategoryName(prodDetail.category_name);
            setQuantity(prodDetail.quantity);
            setStatus(prodDetail.status);
            setseller_name(prodDetail.seller_name);
            setstore_name(prodDetail.store_name);
            
            const catData = await axios.get(`http://localhost/api/category/all`);
            console.log("Check cat data: ", catData.data.data);
            setCatList(catData.data.data);

          } catch (error) {
            console.error("Error fetching data:", error);
          }
        };
      
        fetchData(); // Gọi hàm con
      }, []); // Thêm `productID` vào dependency array
      



    function handleSelectCat(e) {
        setSelectCat(e.target.value != "");
    }

    // function handleChangeDescription(e) {
    //     if (e.target.value.length > 0) setDiscription(true)
    //     else setDiscription(false);
    // }

    function hanldeUpdateProduct() {
        const updateProd = {
            "name": name,
            "brand": brand,
            "price": Number(price),
            "description": description,
            "quantity": Number(quantity),
            "category_id": category,
            "status": status
        }

        console.log(updateProd);


        axios.post(`http://localhost/api/product/update/${productID}`, updateProd)
            .then((response) => {
                // console.log("Check tên sp: ", productName);
                console.log(response);
                alert("Cập nhật sản phẩm thành công!");
                navigate("/")
            })
            .catch((error) => {
                console.log(error);
                navigate("/")
                // if (error.response) {
                //     alert(error.response.data.msg);
                // } else {
                //     console.error('Error:', error.message);
                // }
            })

    }

    return (
        <>
            <Header page="product-manage" role="admin" />
            <main>
                <div className="m-4 mb-10">
                    <span className="text-gray-600">Shop /</span><span /> <span className="font-medium">Update Products</span>
                </div>

                <div className="grid grid-cols-2">
                    <div className="mx-auto w-4/5">
                        <h2 className="font-medium text-3xl" >Sửa sản phẩm</h2>
                        <div className="my-6">
                            <label>Tên sản phẩm <span className="text-red-600">*</span></label>
                            <input type="text" name="pname" className={`pl-4 bg-gray-100 block w-4/5 h-8 my-2 rounded-md `}
                                onChange={(e) => { setname(e.target.value) }}
                                value={name}
                            />
                            
                        </div>

                        <div className="my-6 grid grid-cols-2 gap-2 w-4/5">

                            <div >
                                <label>Người bán</label>
                                <div className="px-2 block w-4/5 h-8 my-2 rounded-md bg-gray-300 " >
                                    <span>{seller_name}</span>
                                </div>
                            </div>

                            <div >
                                <label>Cửa hàng</label>
                                <div className="px-2 block w-4/5 h-8 my-2 rounded-md bg-gray-300 " >
                                    <span>{store_name}</span>
                                </div>
                            </div>

                            
                        </div>


                        <div className="my-6">
                            <label>Danh mục<span className="text-red-600">*</span></label>
                            <select name="category" className={`px-2 block w-4/5 h-8 my-2 rounded-md hover:bg-blue-100 ${selectCat ? 'bg-blue-100' : 'bg-gray-100'} `} 
                                onChange={(e) => setCategory(e.target.value)}
                                value={category}
                            >
                                <option value="" disabled>Chọn loại sản phẩm</option>
                                {catList.length > 0 && catList.map((cat) => (
                                    <option value={cat.id} key={cat.id} >{cat.name}</option>
                                    ))}
                            </select>
                        </div>

                        <div className="my-6">
                            <label>Hãng sản xuất<span className="text-red-600">*</span></label>
                            <input type="text" name="brand" className="pl-4 bg-gray-100 block w-4/5 h-8 my-2 rounded-md hover:bg-blue-100"
                                onChange={(e) => setBrand(e.target.value)}
                                value={brand}
                            />
                        </div>

                        <div className="my-6">
                            <label>Giá thành<span className="text-red-600">*</span></label>
                            <input type="number" name="price" className="pl-4 bg-gray-100 block w-4/5 h-8 my-2 rounded-md"
                                onChange={(e) => setPrice(e.target.value)}
                                value={price}
                            />
                        </div>

                        <div className="my-6">
                            <label>Số lượng trong kho<span className="text-red-600">*</span></label>
                            <input type="number" name="quantity" className="pl-4 bg-gray-100 block w-4/5 h-8 my-2 rounded-md"
                                onChange={(e) => setQuantity(e.target.value)}
                                value={quantity}
                            />
                        </div>

                        <div className="my-6">
                            <label>Trạng thái <span className="text-red-600">*</span></label>
                            <select name="status" className={`px-2 block w-4/5 h-8 my-2 rounded-md hover:bg-blue-100 ${selectCat ? 'bg-blue-100' : 'bg-gray-100'} `} 
                                onChange={(e) => setStatus(e.target.value)}
                                value={status}
                            >
                                <option value="Available" >Available</option>
                               <option value="Stop Selling">Stop Selling</option>
                               <option value="Sold Out">Sold Out</option>
                               
                            </select>
                        </div>


                    </div>
                    <div className="mx-auto w-full">
                        <div className="my-6">
                            <label>Mô tả sản phẩm<span className="text-red-600">*</span></label>
                            <textarea name="price" className={`p-4 block w-4/5 h-80 my-2 rounded-md hover:bg-blue-100 ${description ? "bg-blue-100" : "bg-gray-100"}`}
                                onChange={(e) => setDiscription(e.target.value)}
                                value={description}
                            />
                        
                        </div>

                        <div className="w-full flex justify-center items-center"
                            onClick={() => hanldeUpdateProduct()}
                        >
                            <button className="bg-red-500 text-white p-2 rounded-md pr-3 block mr-40">Cập nhật</button>
                        </div>
                    </div>


                </div>
            </main>

        </>
    )
}