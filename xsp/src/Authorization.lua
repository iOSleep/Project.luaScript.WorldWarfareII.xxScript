Authorization = {
	nowState=0,
}--初始化
function Authorization:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function Check()
	local bb = require("badboy")
	bb.loadluasocket()
	local http = bb.http
	local response_body = {}
	local post_data = 'asd';  
	res, code = http.request{  
		url = 'http://127.0.0.1/post.php',  
		method = "POST",  
		headers =   
		{  
			['Content-Type'] = 'application/x-www-form-urlencoded',  
			['Content-Length'] = #post_data,  
		},  
		source = ltn12.source.string('data=' .. post_data),  
		sink = ltn12.sink.table(response_body)  
	}  
	return res
end