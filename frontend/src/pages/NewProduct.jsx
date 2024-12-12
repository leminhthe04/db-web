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
    const [status, setStatus] = useState("Available");
    const [sellerList, setSellerList] = useState([]);
    const [seller_id, setSeller_id] = useState(null);
    const [storeList, setStoreList] = useState([]);
    const [store_id, setStore_id] = useState(null); 

    // FUNCTION

    useEffect(() => {
        const fetchData = async () => {
          try {
            const sellerData = await axios.post(`http://localhost/api/seller/get`, { "limit": 999999, "offset": 0 });
            console.log("Check seller data: ", sellerData.data.data);
            setSellerList(sellerData.data.data);
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

    async function selectSeller(event) {
        setSeller_id(event.target.value);
        console.log("Check seller id: ", event.target.value);
        const storeData = await axios.get(`http://localhost/api/store/get/seller/${event.target.value}`);
        console.log("Check store data: ", storeData.data.data);
        setStoreList(storeData.data.data);
    }



    // function handleChangeDescription(e) {
    //     if (e.target.value.length > 0) setDiscription(true)
    //     else setDiscription(false);
    // }

    function handleCreateProduct() {
        const newProd = {
            "name": name,
            "brand": brand,
            "seller_id": Number(seller_id),
            "store_id": Number(store_id),
            "price": Number(price),
            "description": description,
            "quantity": Number(quantity),
            "category_id": Number(category),
            "status": status
        }

        console.log(newProd);


        axios.post(`http://localhost/api/product/create`, newProd)
            .then((response) => {
                // console.log("Check tên sp: ", productName);
                console.log(response);
                alert("Tạo sản phẩm mới thành công!");
                navigate("/")
            })
            .catch((error) => {
                console.log(error);
                // navigate("/")
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
                    <span className="text-gray-600">Shop /</span><span /> <span className="font-medium">New Product</span>
                </div>

                <div className="grid grid-cols-2">
                    <div className="mx-auto w-4/5">
                        <h2 className="font-medium text-3xl" >Thêm sản phẩm</h2>
                        <div className="my-6">
                            <label>Tên sản phẩm<span className="text-red-600">*</span></label>
                            <input type="text" name="name" className="pl-4 bg-gray-100 block w-4/5 h-8 my-2 rounded-md hover:bg-blue-100"
                                onChange={(e) => setname(e.target.value)}
                                value={name}
                            />
                        </div>

                        <div className="my-6 grid grid-cols-2 gap-2 w-4/5">

                            <div >
                                <label>Người bán</label>
                                <div className="px-2 block w-4/5 h-8 my-2 rounded-md bg-gray-100 " >
                                <select name="seller" className={`px-2 block w-full h-8 my-2 bg-gray-100  rounded-md `} 
                                onChange={selectSeller}
                                value={seller_id}
                            >
                                <option value="" >Chọn người bán</option>
                                {sellerList.length > 0 && sellerList.map((seller) => (
                                    <option value={seller.id} key={seller.id} >{seller.fname+ " " + seller.lname} </option>
                                    ))}
                            </select>
                                </div>
                            </div>

                            <div >
                                <label>Cửa hàng</label>
                                    
                                    <select name="store" className={`px-2 block w-full h-8 my-2 bg-gray-100  rounded-md `} 
                                         onChange={(e) =>{
                                            // alert(e.target.value);
                                             setStore_id(e.target.value)}}
                                           
                                        >
                                        <option value="store">Chọn store</option>
                                        {storeList.length > 0 && storeList.map((store) => (
                                            <option value={Number(store.id)} key={store.id} >{store.name +" " + store.id} </option>
                                            ))}
                                    </select>
                                <div>
                                   
                                </div>
                            </div>

                            
                        </div>


                        <div className="my-6">
                            <label>Danh mục<span className="text-red-600">*</span></label>
                            <select name="category" className={`px-2 block w-4/5 h-8 my-2 rounded-md hover:bg-blue-100 ${selectCat ? 'bg-blue-100' : 'bg-gray-100'} `} 
                                onChange={(e) => setCategory(e.target.value)}
                                value={category}
                            >
                                <option value="" >Chọn loại sản phẩm</option>
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
                            onClick={() => handleCreateProduct()}
                        >
                            <button className="bg-red-500 text-white p-2 rounded-md pr-3 block mr-40">Tạo sản phẩm</button>
                        </div>
                    </div>


                </div>
            </main>

        </>
    )
}