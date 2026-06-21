var siz2;
/*数据初始化-开始*/
$("#map1").html(beihai)
$(".bodyMiddle .navbar").find("span").each(function(index, item) {
	$(this).click(function() {
		$(".bodyMiddle .navbar").find("span").removeClass("active");
		$(".mapmain").find(".map").hide();
		$(this).addClass("active");
		$(".mapmain").find(".map").eq(index).fadeIn(300);
		// 如果是加州地图（第一个选项卡），重新调整大小
		if (index === 0) {
			setTimeout(function() {
				var chart = echarts.getInstanceByDom($("#map")[0]);
				if (chart) {
					chart.resize();
				}
			}, 350);
		}
	})
})

// 从后端加载投资推荐数据并渲染表格
function loadInvestRecommendData() {
	$.ajax({
		url: "/page/api/investRecommend",
		type: "GET",
		dataType: "json",
		success: function(backendData) {
			// 清空容器
			$(".liushuihaoul .moveul").empty();
			// 渲染后端数据到表格
			backendData.forEach(item => {
				$(".liushuihaoul .moveul").append(`<li>
                    <span>${item.regionId}</span>
                    <span>${item.currentHouseValue}</span>
                    <span>${item.residentIncome}</span>
                    <span>${item.houseAge}</span>
                    <span>${item.investmentScore}</span>
                    <span>${item.geographicArea}</span>
                </li>`);
			});
			// 初始化无缝滚动布局
			siz2 = $(".liushuihaoul .moveul").find("li").length;
			$(".liushuihaoul .moveul").css('height', $(".liushuihaoul .moveul").find("li").length * 50);
			// 复制列表实现无缝滚动
			$(".liushuihaoul .moveul").html(function(index, value) {
				return value + value;
			});
			console.log("✅ 投资推荐区域数据加载完成");
		},
		error: function(xhr, status, error) {
			console.error("Invest recommend data load failed: ", error);
			alert("投资推荐数据加载失败，请检查后端服务！");
		}
	});
}

// 页面加载时执行数据加载
$(function() {
	loadInvestRecommendData();
	// 隐藏成交动态的选项卡容器（保留原有优化）
	$(".bodyRightTop .navbar").hide();
});





//数据中心
for (var i = 0; i < DataCenter.length; i++) {
	$(".Data").html(function(index, html) {
		return html += `<li><span>${DataCenter[i].num}</span><p>${DataCenter[i].name}</p><i></i></li>`
	})
};
//占比小方块
for (var i = 0; i < 10; i++) {
	$(".GPZB").find("ul").html(function(index, html) {
		return html += `<li></li>`
	})
};
//六个竖直小方块组
for (var i = 0; i < 13; i++) {
	$(".fangkuai").html(function(index, html) {
		return html += `<li></li>`
	})
};
//时间刻度
for (var i = 0; i < 13; i++) {
	$(".kedu").find("ul").html(function(index, html) {
		return html += `<li></li>`
	})
};

var show = true;
/*数据初始化-开始*/
function rdm(min, max) {
	return parseInt(Math.random() * (max - min) + min);
}

// ad()
guapai($(".guapai")[0]);
guapaizhanbi($(".left-top-right-circle")[0]);

//时间
(function() {
	let adata = new Date();
	let weekarr = ["日", "一", "二", "三", "四", "五", "六"];
	let time = adata.getHours() + ":" + Fill(adata.getMinutes()) + ":" + Fill(adata.getSeconds());
	let year = adata.getFullYear() + "年" + (adata.getMonth() + 1) + "月" + adata.getDate() + "日";
	let week = adata.getDay();

	function Fill(data) { //分钟秒钟空位补0
		if (data < 10) {
			return "0" + data;
		} else {
			return data;
		}
	}
	$("#time").text(time);
	$("#year").text(year);
	$("#week").text("星期" + weekarr[week]);
	setInterval(function() {
		adata = new Date();
		weekarr = ["日", "一", "二", "三", "四", "五", "六"];
		time = adata.getHours() + ":" + Fill(adata.getMinutes()) + ":" + Fill(adata.getSeconds());
		year = adata.getFullYear() + "年" + (adata.getMonth() + 1) + "月" + adata.getDate() + "日";
		week = adata.getDay();
		$("#time").text(time);
		$("#year").text(year);
		$("#week").text("星期" + weekarr[week]);
	}, 1000)
	//天气接口
	let wetherarr = ["多云", "8~-2℃", "优"];
	$("#sky").text(wetherarr[0])
	$("#temperatur").text(wetherarr[1])
	$("#state").text(wetherarr[2])
}());

//房屋价值TOP10+
function guapai(obj) {
	// 1. AJAX request backend data
	$.ajax({
		url: "/page/api/houseTop10",
		type: "GET",
		dataType: "json",
		success: function(top10HouseData) {
			// 2. Format data (add ranking text: "Rank 1", "Rank 2"... )
			const formattedData = top10HouseData.map(item => ({
				...item,
				rankText: `Rank ${item.ranking}`
			}));

			// 3. Initialize ECharts instance
			const myChart = echarts.init(obj);
			const option = {
				tooltip: {
					trigger: 'item',
					axisPointer: { type: 'shadow' },
					textStyle: { fontSize: 12 },
					formatter: function(params) {
						const dataItem = formattedData[params.dataIndex];
						return `房屋价值：${dataItem.houseValue.toLocaleString()}<br>居民收入中位数：$${dataItem.medianIncome.toLocaleString()}<br>房屋平均年龄：${dataItem.avgHouseAge} years`;
					}
				},
				grid: {
					top: "15%",
					left: '6%',
					right: '30%',
					bottom: '10%',
					containLabel: true
				},
				xAxis: {
					type: 'value',
					name: "房屋价值",
					nameTextStyle: { color: "#fff", fontSize: "14" },
					nameGap: 20,
					axisTick: { lineStyle: { color: "#fff" } },
					axisLabel: {
						color: "#fff",
						fontSize: "12",
						formatter: value => value.toLocaleString()
					},
					axisLine: {
						show: true,
						lineStyle: { color: "#fff", width: "2" },
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					},
					splitLine: {
						show: true,
						lineStyle: { color: "#02416D", width: "1" }
					}
				},
				yAxis: {
					type: 'category',
					data: formattedData.map(item => item.rankText),
					nameTextStyle: { color: "#fff", fontSize: "14" },
					nameGap: 20,
					axisTick: { lineStyle: { color: "#fff" } },
					axisLabel: { color: "#fff", fontSize: "12", interval: 0 },
					axisLine: {
						show: true,
						lineStyle: { color: "#fff", width: "2" },
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					}
				},
				series: [{
					name: 'House Value',
					type: 'bar',
					color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [{
						offset: 0,
						color: '#3E3CB5'
					}, {
						offset: 1,
						color: '#D66BFD'
					}]),
					barWidth: 25,
					label: { show: true, color: "#fff", fontSize: 12, position: "right" },
					data: formattedData.map(item => item.houseValue)
				}]
			};
			myChart.setOption(option);
			window.addEventListener('resize', () => myChart.resize());
		},
		error: function(xhr, status, error) {
			console.error("House Value TOP10 data load failed: ", error);
			alert("Data load failed, please check backend service!");
		}
	});
};

//房屋价值 TOP10  右侧区域
function guapaizhanbi(obj) {
	// 第一步：添加AJAX请求，替换原有静态数据
	$.ajax({
		url: "/page/api/houseValue", // 对应后端完整接口路径
		type: "GET",
		dataType: "json",
		success: function(data) {
			// 1. 从后端数据中提取值（替换原有静态数组）
			var echartdata = [data.highValue || 0, data.midValue || 0, data.lowValue || 0];

			// 2. 以下所有代码完全复用你原来的逻辑，无需修改
			var rich = {
				yellow: {
					color: "#ffc72b",
					fontSize: 18,
					padding: [2, 4],
					align: 'center',
					lineHeight: 20
				},
				white: {
					color: "#fff",
					align: 'center',
					fontSize: 16,
					padding: [10, 0],
					lineHeight: 25
				},
				blue: {
					color: '#49dff0',
					fontSize: 16,
					align: 'center',
					lineHeight: 18
				}
			};

			var myChart = echarts.init(obj);
			var option = {
				tooltip: {
					trigger: 'item',
					formatter: "{b}: {c} (占房屋价值TOP10比例：{d}%)"
				},
				series: [{
					type: 'pie',
					label: {
						fontSize: 24,
						normal: {
							color: "#fff",
							position: 'outside',
							formatter: function(params) {
								var total = echartdata.reduce((a, b) => a + b, 0);
								var percent = ((params.value / total) * 100).toFixed(1);
								return '{white|' + params.name + '}\n{yellow|' + params.value + '}\n{blue|' + percent + '%}';
							},
							padding: [0, 10],
							rich: rich
						}
					},
					labelLine: {
						lineStyle: {
							width: 2,
							color: "#fff"
						},
						length: 20,
						length2: 40
					},
					radius: ['40%', '60%'],
					data: [{
						value: echartdata[0],
						itemStyle: { color: "#1D3EF9" },
						name: '高价值区'
					}, {
						value: echartdata[1],
						itemStyle: { color: "#FBED14" },
						name: '中价值区'
					}, {
						value: echartdata[2],
						itemStyle: { color: "#3BF88F" },
						name: '低价值区'
					}]
				}]
			};
			myChart.setOption(option);

			// 窗口自适应（可选，可添加）
			window.addEventListener("resize", function() {
				myChart.resize();
			});

			// 格子渲染逻辑 - 修改为按比例显示
			var Oitem = $(".bodyLeftTopGPZB");

			function renderHouseValueGrid() {
				var gridNames = ["高价值区", "中价值区", "低价值区"];

				// 计算总价值
				var totalValue = echartdata[0] + echartdata[1] + echartdata[2];
				if (totalValue === 0) totalValue = 1; // 避免除零错误

				Oitem.each((index, item) => {
					$(item).find(".GPZB").each((i, gpzbItem) => {
						// 更新标题和数值
						$(gpzbItem).find(".title").text(gridNames[i]);
						$(gpzbItem).find("span").text(echartdata[i]);

						// 获取现有的格子容器和所有格子
						var gridContainer = $(gpzbItem).find("ul, .grid-container, .grid-list");
						var liElements = gridContainer.find("li");

						// 获取当前已有的格子总数
						var totalGrids = liElements.length;
						if (totalGrids === 0) {
							totalGrids = 20;
							gridContainer.empty();
							for (var j = 0; j < totalGrids; j++) {
								var li = $('<li></li>').css({
									"width": "12px",
									"height": "12px",
									"margin": "2px",
									"display": "inline-block",
									"background": "#1D2088"
								});
								gridContainer.append(li);
							}
							// 重新获取格子元素
							liElements = gridContainer.find("li");
						}

						// 计算应该填充的格子数（按比例）
						var fillGrids = Math.round((echartdata[i] / totalValue) * totalGrids);

						// 确保填充格子数在合理范围内
						fillGrids = Math.max(0, Math.min(fillGrids, totalGrids));

						// 更新格子颜色
						liElements.each(function(ind, ite) {
							if (ind < fillGrids) {
								$(ite).css("background", "#00A0E9");
							} else {
								$(ite).css("background", "#1D2088");
							}
						});
					});
				});
			}

			// 在页面加载完成后渲染格子
			renderHouseValueGrid();
		},
		error: function(xhr, status, error) {
			console.error("数据请求失败：", status, error);
			alert("接口请求失败，请检查后端服务！");
		}
	});
}



/**
 * 加州房价热力图加载器 - 简化版
 */
var CaliforniaHeatmapLoader = {
	// 地图实例
	chart: null,
	// 加州地图数据URL
	californiaJsonUrl: '../json/California.json',
	// 后端API地址
	apiEndpoints: {
		countyIncome: '/page/api/countyIncome' // 获取县收入数据
	},

	// 地图配置
	mapConfig: {
		containerId: 'map',
		zoom: 1,
		center: [4500, 4500], // 加州中心坐标
		roam: true
	},
	// 数据缓存
	cachedData: {
		countyPrices: null, // 县房价数据
		californiaGeoJson: null // 加州地理数据
	},
	// 颜色配置
	colorConfig: {
		// 房价颜色渐变（从低到高）
		priceColors: ['#f7fbff', '#deebf7', '#c6dbef', '#9ecae1', '#6baed6', '#4292c6', '#2171b5', '#08519c', '#08306b'],
		// 基础颜色
		baseColor: '#f0f5ff',
		// 高亮颜色
		highlightColor: '#1890ff',
		// 边框颜色
		borderColor: '#8c8c8c',
		// 文字颜色
		labelColor: '#1890ff'
	},

	/**
	 * 初始化加州房价热力图
	 */
	init: function(callback) {
		console.log('🌎 开始加载加州房价热力图...');
		console.log('地图容器ID:', this.mapConfig.containerId);

		// 获取DOM容器并设置高度
		var chartDom = document.getElementById(this.mapConfig.containerId);
		if (!chartDom) {
			console.error('❌ 找不到地图容器元素: #' + this.mapConfig.containerId);
			alert('找不到地图容器，请检查页面结构');
			return;
		}
		// 设置容器高度为1000px，并添加上边距
		chartDom.style.height = '1000px';
		console.log('✅ 设置地图容器高度为1000px');
		console.log('✅ 找到地图容器，尺寸:', chartDom.offsetWidth + 'x' + chartDom.offsetHeight);
		// 初始化ECharts实例
		try {
			this.chart = echarts.init(chartDom);
			console.log('✅ ECharts实例初始化成功');
		} catch (error) {
			console.error('❌ ECharts初始化失败:', error);
			alert('地图引擎初始化失败: ' + error.message);
			return;
		}
		// 显示加载状态
		this.chart.showLoading({
			text: '正在加载加州房价数据...',
			color: '#1890ff',
			textColor: '#333',
			maskColor: 'rgba(255, 255, 255, 0.8)'
		});
		// 从后端加载数据
		this._loadDataFromBackend(callback);
	},

	/**
	 * 从后端加载数据
	 */
	_loadDataFromBackend: function(callback) {
		console.log('📡 正在从后端加载数据...');

		// 并行加载地图数据和房价数据
		Promise.all([
			this._loadCaliforniaGeoJson(),
			this._fetchCountyIncomeData()
		])
			.then(([geoJson, countyData]) => {
				console.log('✅ 所有数据加载完成');
				console.log('地理数据特征数:', geoJson.features ? geoJson.features.length : 0);
				console.log('房价数据数量:', countyData ? Object.keys(countyData).length : 0);

				// 缓存数据
				this.cachedData.californiaGeoJson = geoJson;
				this.cachedData.countyPrices = countyData;

				// 隐藏加载动画
				this.chart.hideLoading();

				// 渲染房价热力图
				this._renderHeatmap();

				// 执行回调
				if (typeof callback === 'function') {
					callback({ geoJson: geoJson, countyData: countyData });
				}
			})
			.catch(error => {
				console.error('❌ 加载数据失败:', error);

				// 隐藏加载动画
				this.chart.hideLoading();

				// 显示错误信息
				this._showDetailedError(error);

				if (typeof callback === 'function') {
					callback(null, error);
				}
			});
	},

	/**
	 * 加载加州地理数据
	 */
	_loadCaliforniaGeoJson: function() {
		return new Promise((resolve, reject) => {
			console.log('正在加载加州地理数据...');

			fetch(this.californiaJsonUrl)
				.then(response => {
					if (!response.ok) {
						throw new Error(`HTTP ${response.status}: ${response.statusText}`);
					}
					return response.json();
				})
				.then(geoJson => {
					// 验证数据格式
					if (!geoJson || geoJson.type !== 'FeatureCollection') {
						throw new Error('地理数据格式不正确');
					}

					// 注册加州地图
					echarts.registerMap('California', geoJson);
					console.log('✅ 加州地图注册成功');
					resolve(geoJson);
				})
				.catch(error => {
					console.error('加载地理数据失败:', error);
					reject(error);
				});
		});
	},

	/**
	 * 获取县收入数据
	 */
	_fetchCountyIncomeData: function() {
		return new Promise((resolve, reject) => {
			console.log('正在获取县收入数据...');
			console.log('API URL:', this.apiEndpoints.countyIncome);

			$.ajax({
				url: this.apiEndpoints.countyIncome,
				type: "GET",
				dataType: "json",
				timeout: 10000, // 10秒超时
				success: function(data) {
					console.log('✅ 县收入数据获取成功，数量:', data.length);
					var formattedData = {};
					data.forEach(item => {
						if (item.englishName && item.price !== null && item.price !== undefined) {
							formattedData[item.englishName] = {
								chinese: item.chineseName || item.englishName,
								price: parseFloat(item.price) || 0
							};
						}
					});

					// 检查是否有数据
					if (Object.keys(formattedData).length === 0) {
						reject(new Error('后端返回数据为空或格式不正确'));
						return;
					}

					console.log('✅ 成功格式化', Object.keys(formattedData).length, '个县的数据');
					resolve(formattedData);
				},
				error: function(xhr, status, error) {
					var errorMessage = `API调用失败: ${status}`;
					if (xhr.status === 404) {
						errorMessage = `API接口不存在 (404): ${this.apiEndpoints.countyIncome}`;
					} else if (xhr.status === 500) {
						errorMessage = '服务器内部错误 (500)';
					} else if (status === 'timeout') {
						errorMessage = '请求超时';
					}

					console.error('获取县收入数据失败:', errorMessage);
					reject(new Error(errorMessage));
				}.bind(this)
			});
		});
	},

	/**
	 * 渲染房价热力图
	 */
	_renderHeatmap: function() {
		if (!this.chart) {
			console.error('❌ 地图实例未初始化');
			return;
		}

		console.log('🎨 开始渲染加州房价热力图...');
		console.log('房价数据:', this.cachedData.countyPrices);

		// 准备地图数据
		var mapData = this._prepareHeatmapData();
		var priceRange = this._getPriceRange();

		// 配置选项
		var option = {
			backgroundColor: 'transparent',

			tooltip: {
				trigger: 'item',
				backgroundColor: 'rgba(50, 50, 50, 0.95)',
				borderColor: '#444',
				borderWidth: 1,
				borderRadius: 6,
				padding: 12,
				textStyle: {
					color: '#fff',
					fontSize: 13
				},
				formatter: (params) => {
					return this._getHeatmapTooltipContent(params);
				}
			},

			visualMap: {
				show: true,
				left: 20,
				top: 100,
				min: priceRange.min,
				max: priceRange.max,
				text: ['低房价', '高房价'],
				realtime: false,
				calculable: true,
				inRange: {
					color: this.colorConfig.priceColors
				},
				textStyle: {
					color: '#333',
					fontSize: 12
				},
				formatter: function(value) {
					if (value >= 1000000) {
						return '$' + (value / 1000000).toFixed(1) + 'M';
					}
					return '$' + (value / 1000).toFixed(0) + 'K';
				}
			},

			series: [{
				name: '加州房价',
				type: 'map',
				map: 'California',
				roam: true,
				zoom: this.mapConfig.zoom,
				center: this.mapConfig.center,
				scaleLimit: {
					min: 1,
					max: 20
				},

				// 数据配置
				data: mapData,

				// 标签配置
				label: {
					show: true,
					color: this.colorConfig.labelColor,
					fontSize: 14,
					fontWeight: 'bold',
					formatter: '{b}',
					textBorderColor: '#fff',
					textBorderWidth: 2
				},

				// 默认样式
				itemStyle: {
					borderColor: this.colorConfig.borderColor,
					borderWidth: 1,
					borderType: 'solid',
					areaColor: this.colorConfig.baseColor,
					opacity: 0.9
				},

				// 高亮样式
				emphasis: {
					label: {
						show: true,
						color: this.colorConfig.highlightColor,
						fontSize: 13,
						fontWeight: 'bold',
						backgroundColor: 'rgba(0,0,0,0.8)',
						padding: [5, 10],
						borderRadius: 4
					},
					itemStyle: {
						areaColor: this.colorConfig.highlightColor,
						shadowColor: 'rgba(255, 127, 80, 0.6)',
						shadowBlur: 12,
						borderColor: this.colorConfig.highlightColor,
						borderWidth: 3
					}
				}
			}]
		};

		// 设置配置并渲染
		try {
			this.chart.setOption(option, true);
			console.log('✅ 加州房价热力图渲染完成');
			console.log('📊 房价范围: $' + priceRange.min.toLocaleString() + ' - $' + priceRange.max.toLocaleString());
			console.log('📊 渲染县数量:', mapData.length);
			// 添加事件监听
			this._bindEvents();
			// 调整地图大小
			this.resize();
		} catch (error) {
			console.error('❌ 热力图渲染失败:', error);
			this._showError('热力图渲染失败: ' + error.message);
		}
	},

	/**
	 * 准备热力图数据
	 */
	_prepareHeatmapData: function() {
		var mapData = [];
		if (this.cachedData.countyPrices) {
			Object.keys(this.cachedData.countyPrices).forEach(countyName => {
				var countyData = this.cachedData.countyPrices[countyName];
				if (countyData && countyData.price !== null && countyData.price !== undefined) {
					mapData.push({
						name: countyName,
						value: countyData.price,
						chineseName: countyData.chinese,
						itemStyle: {
							areaColor: this._getColorByPrice(countyData.price)
						}
					});
				}
			});
		}

		console.log('热力图数据数量:', mapData.length);
		return mapData;
	},

	/**
	 * 根据价格获取颜色
	 */
	_getColorByPrice: function(price) {
		var colors = this.colorConfig.priceColors;
		var priceRange = this._getPriceRange();

		if (price <= priceRange.min) return colors[0];
		if (price >= priceRange.max) return colors[colors.length - 1];

		var ratio = (price - priceRange.min) / (priceRange.max - priceRange.min);
		var index = Math.floor(ratio * (colors.length - 1));

		return colors[index];
	},

	/**
	 * 获取价格范围
	 */
	_getPriceRange: function() {
		var min = Infinity;
		var max = -Infinity;

		if (this.cachedData.countyPrices) {
			Object.values(this.cachedData.countyPrices).forEach(county => {
				if (county.price !== null && county.price !== undefined) {
					var price = parseFloat(county.price);
					if (!isNaN(price)) {
						if (price < min) min = price;
						if (price > max) max = price;
					}
				}
			});
		}
		// 设置默认范围
		if (min === Infinity) min = 200000;
		if (max === -Infinity) max = 2000000;
		// 确保有一定范围
		if (max - min < 100000) {
			min = Math.max(0, min - 50000);
			max = max + 50000;
		}

		return { min: Math.round(min), max: Math.round(max) };
	},

	/**
	 * 获取热力图Tooltip内容
	 */
	_getHeatmapTooltipContent: function(params) {
		var countyName = params.name;
		var countyData = this.cachedData.countyPrices ? this.cachedData.countyPrices[countyName] : null;

		if (!countyData) {
			return `<div style="font-size: 14px; color: #1890ff; font-weight: bold;">
				${countyName} 县<br/>
				房价数据加载中...
			</div>`;
		}
		var price = countyData.price || 0;
		var chineseName = countyData.chinese || countyName;

		// 获取县排名
		var rank = this._getCountyRank(countyName);

		// 计算州平均
		var stats = this._calculateStatistics();

		var html = `<div style="font-size: 14px; line-height: 1.6; min-width: 220px;">
			<div style="color:#1890ff; font-weight:bold; margin-bottom: 10px; border-bottom: 1px solid #444; padding-bottom: 5px;">
				📍 ${chineseName}
			</div>
			
			<div style="margin-bottom: 8px;">
				<span>🏠 平均房价: </span>
				<span style="float:right; font-weight:bold; color:#ffd700;">
					$${price.toLocaleString()}
				</span>
			</div>`;

		if (rank > 0) {
			html += `<div style="margin-bottom: 8px;">
				<span>🏆 全州排名: </span>
				<span style="float:right; font-weight:bold; color:${rank <= 10 ? '#52c41a' : '#666'}">
					第 ${rank} 名
				</span>
			</div>`;
		}

		if (stats.averagePrice > 0) {
			var diff = price - stats.averagePrice;
			var diffPercent = ((diff / stats.averagePrice) * 100).toFixed(1);

			html += `<div style="margin-bottom: 8px;">
				<span>📊 对比州平均: </span>
				<span style="float:right; font-weight:bold; color:${diff >= 0 ? '#f5222d' : '#52c41a'}">
					${diff >= 0 ? '+' : ''}${diffPercent}%
				</span>
			</div>`;

			if (Math.abs(diff) > 0) {
				html += `<div style="margin-bottom: 8px; font-size: 12px; color: #aaa;">
					${diff >= 0 ? '高于' : '低于'}州平均 $${Math.abs(diff).toLocaleString()}
				</div>`;
			}
		}

		html += `</div>`;
		return html;
	},

	/**
	 * 获取县排名
	 */
	_getCountyRank: function(countyName) {
		if (!this.cachedData.countyPrices) return -1;

		var counties = [];
		Object.keys(this.cachedData.countyPrices).forEach(name => {
			var county = this.cachedData.countyPrices[name];
			if (county && county.price !== null && county.price !== undefined) {
				counties.push({
					name: name,
					price: parseFloat(county.price) || 0
				});
			}
		});
		counties.sort((a, b) => b.price - a.price);
		for (var i = 0; i < counties.length; i++) {
			if (counties[i].name === countyName) {
				return i + 1;
			}
		}
		return -1;
	},

	/**
	 * 计算统计信息
	 */
	_calculateStatistics: function() {
		if (!this.cachedData.countyPrices) {
			return { averagePrice: 0, totalCounties: 0, maxPrice: 0, minPrice: 0 };
		}
		var totalPrice = 0;
		var countyCount = 0;
		var maxPrice = -Infinity;
		var minPrice = Infinity;
		Object.values(this.cachedData.countyPrices).forEach(county => {
			if (county.price !== null && county.price !== undefined) {
				var price = parseFloat(county.price);
				if (!isNaN(price)) {
					totalPrice += price;
					countyCount++;
					if (price > maxPrice) maxPrice = price;
					if (price < minPrice) minPrice = price;
				}
			}
		});
		return {
			averagePrice: countyCount > 0 ? Math.round(totalPrice / countyCount) : 0,
			totalCounties: countyCount,
			maxPrice: maxPrice !== -Infinity ? Math.round(maxPrice) : 0,
			minPrice: minPrice !== Infinity ? Math.round(minPrice) : 0
		};
	},
	/**
	 * 显示详细错误信息
	 */
	_showDetailedError: function(error) {
		var errorMessage = '加载加州房价数据失败\n\n';

		if (error.message.includes('HTTP')) {
			errorMessage += '❌ 网络请求失败\n';
			errorMessage += '请检查以下问题：\n';
			errorMessage += '1. 文件路径是否正确: ' + this.californiaJsonUrl + '\n';
			errorMessage += '2. 文件是否存在于服务器\n';
			errorMessage += '3. 是否有访问权限\n';
			errorMessage += '\n错误详情：' + error.message;
		} else if (error.message.includes('JSON')) {
			errorMessage += '❌ 数据格式错误\n';
			errorMessage += '数据可能不是有效的JSON格式\n';
			errorMessage += '\n错误详情：' + error.message;
		} else if (error.message.includes('register')) {
			errorMessage += '❌ 地图注册失败\n';
			errorMessage += 'GeoJSON数据格式可能不正确\n';
			errorMessage += '\n错误详情：' + error.message;
		} else {
			errorMessage += '❌ 未知错误\n';
			errorMessage += '\n错误详情：' + error.message;
		}
		alert(errorMessage);
		// 同时在页面上显示错误
		this._showError(errorMessage);
	},
	/**
	 * 显示错误信息在页面上
	 */
	_showError: function(message) {
		var container = document.getElementById(this.mapConfig.containerId);
		if (container && this.chart) {
			var errorOption = {
				graphic: {
					type: 'text',
					left: 'center',
					top: 'middle',
					style: {
						text: '加载失败\n' + message.split('\n')[0],
						fontSize: 16,
						fill: '#ff4d4f',
						fontWeight: 'bold'
					}
				}
			};
			this.chart.setOption(errorOption);
		}
	},

	/**
	 * 绑定事件
	 */
	_bindEvents: function() {
		if (!this.chart) return;
		// 只保留窗口大小变化事件
		window.addEventListener('resize', () => {
			this.resize();
		});
	},

	/**
	 * 调整地图大小
	 */
	resize: function() {
		if (this.chart) {
			try {
				this.chart.resize();
				console.log('🔄 地图已调整大小');
			} catch (error) {
				console.error('调整地图大小时出错:', error);
			}
		}
	},

	/**
	 * 销毁地图
	 */
	destroy: function() {
		if (this.chart) {
			this.chart.dispose();
			this.chart = null;
			console.log('🗑️ 地图已销毁');
		}
	},

	/**
	 * 重置视图
	 */
	resetView: function() {
		if (this.chart) {
			this.chart.setOption({
				series: [{
					center: [-119.5, 37.5],
					zoom: 5
				}]
			});
			console.log('🔄 视图已重置');
		}
	},

	/**
	 * 更新数据
	 */
	updateData: function() {
		console.log('🔄 更新房价数据...');
		if (this.chart) {
			this.chart.showLoading();
			this._fetchCountyIncomeData()
				.then(countyData => {
					this.cachedData.countyPrices = countyData;
					this._renderHeatmap();
					console.log('✅ 房价数据已更新');
				})
				.catch(error => {
					console.error('更新数据失败:', error);
					this.chart.hideLoading();
					this._showError('更新数据失败: ' + error.message);
				});
		}
	}
};

// 页面加载完成后初始化热力图
$(document).ready(function() {
	console.log('📄 页面加载完成，开始加载加州房价热力图...');

	// 检查必要的库
	if (typeof echarts === 'undefined') {
		console.error('❌ ECharts未加载');
		alert('请先加载ECharts库');
		return;
	}

	if (typeof $ === 'undefined') {
		console.error('❌ jQuery未加载');
		alert('请先加载jQuery库');
		return;
	}

	// 修改地图容器的CSS样式
	_adjustMapContainerStyles();

	// 初始化热力图
	CaliforniaHeatmapLoader.init(function(data, error) {
		if (error) {
			console.error('热力图初始化失败:', error);
		} else {
			console.log('✅ 加州房价热力图初始化完成');
		}
	});
});

/**
 * 调整地图容器样式
 */
function _adjustMapContainerStyles() {
	var mapContainer = document.getElementById('map');
	if (mapContainer) {
		// 设置容器样式，添加上边距100px
		mapContainer.style.cssText = `
			width: 100%;
			height: 1000px !important;
			background: transparent !important;
			margin: 50px 0 0 0;
			padding: 0;
			border: none;
		`;

		console.log('✅ 已设置地图容器高度为1000px，上边距为100px，背景为透明');
	}

	// 添加样式到head
	var style = document.createElement('style');
	style.textContent = `
		#map {
			width: 100% !important;
			height: 1000px !important;
			background: transparent !important;
			margin: 50px 0 0 0 !important;
			padding: 0 !important;
			border: none !important;
			position: relative;
		}
		
		#map .echarts {
			width: 100% !important;
			height: 100% !important;
			background: transparent !important;
		}
	`;
	document.head.appendChild(style);
}
// 导出到全局
window.CaliforniaHeatmapLoader = CaliforniaHeatmapLoader;





//大盘走势（每户平均房间数与房价关系趋势）
(function() {
	// 1. AJAX请求后端数据
	$.ajax({
		url: "/page/api/roomPrice",
		type: "GET",
		dataType: "json",
		success: function(backendData) {
			// 2. 提取前端所需数据
			const roomPriceData = {
				roomSizes: backendData.map(item => item.roomSize),
				avgHousePrice: backendData.map(item => item.avgHousePrice),
				avgIncome: backendData.map(item => item.avgIncome),
				regionCount: backendData.map(item => item.regionCount)
			};
			// 3. 初始化echarts实例
			var myChart = echarts.init($("#map2")[0]);
			// 4. 图表配置项（复用原有逻辑）
			var option = {
				textStyle: {
					color: "#fff",
					fontSize: 20,
					fontWeight: "lighter"
				},
				tooltip: {
					trigger: 'axis',
					textStyle: { color: "#fff" },
					backgroundColor: "rgba(0, 20, 50, 0.8)",
					formatter: params => {
						return `${params[0].name}<br>平均房价：${params[0].value}<br>平均收入：${params[1].value}<br>区域数量：${roomPriceData.regionCount[params[0].dataIndex]}`;
					}
				},
				legend: {
					data: ['平均房价', '平均收入'],
					top: 30,
					right: 20,
					itemGap: 20,
					textStyle: {
						color: "#fff",
						fontSize: "18"
					}
				},
				grid: {
					top: "20%",
					left: '8%',
					right: '15%',
					bottom: '10%',
					containLabel: true
				},
				color: ['#03A2E9', '#46B05D'],
				xAxis: {
					type: 'category',
					name: "户型分类",
					nameTextStyle: {
						color: "#fff",
						fontSize: "20"
					},
					data: roomPriceData.roomSizes,
					axisLine: {
						show: true,
						lineStyle: {
							color: "#fff",
							width: "2"
						},
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					},
					axisTick: {
						lineStyle: {
							color: "#fff",
							width: "2"
						}
					},
					axisLabel: {
						textStyle: {
							color: "#fff",
							fontSize: 14,
							interval: 0
						},
						rotate: 20
					}
				},
				yAxis: {
					type: 'value',
					min: 0,
					name: "指标数值",
					nameTextStyle: {
						color: "#fff",
						fontSize: "20"
					},
					axisLine: {
						show: true,
						lineStyle: {
							color: "#fff",
							width: "2"
						},
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					},
					splitLine: {
						show: true,
						lineStyle: {
							color: "#02416D",
							width: "0.5"
						}
					},
					axisLabel: {
						textStyle: {
							color: "#fff",
							fontSize: 16
						}
					}
				},
				series: [{
					name: '平均房价',
					type: 'line',
					symbolSize: "8",
					itemStyle: {
						borderColor: "#03A2E9",
						borderWidth: 3
					},
					areaStyle: {
						color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
							offset: 0,
							color: 'rgba(3,160,230,.1)'
						}, {
							offset: 1,
							color: 'rgba(3,160,230,.3)'
						}])
					},
					smooth: false,
					data: roomPriceData.avgHousePrice
				}, {
					name: '平均收入',
					type: 'line',
					symbolSize: "8",
					itemStyle: {
						borderColor: "#46B05D",
						borderWidth: 3
					},
					areaStyle: {
						color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
							offset: 0,
							color: 'rgba(62,155,93,.1)'
						}, {
							offset: 1,
							color: 'rgba(62,155,93,.3)'
						}])
					},
					smooth: false,
					data: roomPriceData.avgIncome
				}]
			};

			// 5. 渲染图表
			myChart.setOption(option);

			// 6. 窗口自适应
			window.addEventListener('resize', function() {
				myChart.resize();
			});
		},
		error: function(xhr, status, error) {
			console.error("Room-Price data load failed: ", error);
			alert("Data load failed, please check backend service!");
		}
	});
}());

//房龄-价值衰减曲线
(function() {
	// 1. AJAX请求后端数据
	$.ajax({
		url: "/page/api/ageValue",
		type: "GET",
		dataType: "json",
		success: function(backendData) {
			// 2. 提取前端所需数据
			var ageData = {
				ageRange: backendData.map(item => item.ageRange),
				avgHouseValue: backendData.map(item => item.avgHouseValue),
				avgIncome: backendData.map(item => item.avgIncome),
				avgRooms: backendData.map(item => item.avgRooms)
			};

			// 3. 初始化echarts实例
			var myChart = echarts.init($("#jiagezoushi")[0]);

			// 4. 图表配置项（复用原有逻辑）
			var option = {
				textStyle: {
					color: "#fff",
					fontSize: 24,
					fontWeight: "lighter"
				},
				nameTextStyle: {
					color: "#0BA4E8",
					fontWeight: "normal"
				},
				tooltip: {
					trigger: 'axis',
					textStyle: {
						fontSize: 16,
						color: "#fff"
					},
					backgroundColor: "rgba(0, 20, 50, 0.8)",
					formatter: function(params) {
						var res = params[0].name + '<br';
						params.forEach(item => {
							res += item.seriesName + '：' + item.value.toFixed(3) + '<br';
						});
						return res;
					}
				},
				legend: {
					data: ['平均房屋价值', '平均居民收入', '每户平均房间数'],
					right: 70,
					top: 20,
					textStyle: {
						color: "#fff",
						fontSize: "22"
					},
					itemGap: 30
				},
				grid: {
					top: "25%",
					left: '5%',
					right: '16%',
					bottom: '6%',
					containLabel: true
				},
				color: ['#03A2E9', '#46B05D', '#AF4B87'],
				xAxis: {
					type: 'category',
					name: "房屋年龄区间",
					nameTextStyle: {
						color: "#fff",
						fontSize: "24"
					},
					nameGap: 20,
					data: ageData.ageRange,
					splitLine: {
						show: true,
						lineStyle: {
							color: "#02416D",
							width: "0.5"
						}
					},
					splitArea: {
						show: false
					},
					axisLine: {
						show: true,
						lineStyle: {
							color: "#fff",
							width: "2"
						},
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					},
					axisTick: {
						lineStyle: {
							color: "#fff",
							width: "2"
						}
					},
					axisLabel: {
						textStyle: {
							color: "#fff",
							fontSize: 20,
							fontWeight: "normal"
						},
						interval: 0
					}
				},
				yAxis: {
					type: 'value',
					min: 0,
					interval: 0.5,
					boundaryGap: false,
					name: "指标数值",
					nameTextStyle: {
						color: "#fff",
						fontSize: "24"
					},
					nameGap: 20,
					axisLine: {
						show: true,
						lineStyle: {
							color: "#fff",
							width: "2"
						},
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					},
					splitLine: {
						show: true,
						lineStyle: {
							color: "#02416D",
							width: "0.5"
						}
					},
					axisTick: {
						lineStyle: {
							color: "#fff",
							width: "2"
						}
					},
					axisLabel: {
						textStyle: {
							color: "#fff",
							fontSize: 20,
							fontWeight: "normal"
						}
					}
				},
				series: [{
					name: '平均房屋价值',
					type: 'line',
					symbolSize: "8",
					itemStyle: {
						borderColor: "#03A2E9",
						borderWidth: 3
					},
					smooth: true,
					data: ageData.avgHouseValue
				}, {
					name: '平均居民收入',
					type: 'line',
					symbolSize: "8",
					itemStyle: {
						borderColor: "#46B05D",
						borderWidth: 3
					},
					smooth: true,
					data: ageData.avgIncome
				}, {
					name: '每户平均房间数',
					type: 'line',
					symbolSize: "8",
					itemStyle: {
						borderColor: "#AF4B87",
						borderWidth: 3
					},
					smooth: true,
					data: ageData.avgRooms
				}]
			};
			// 5. 渲染图表
			myChart.setOption(option);

			// 6. 窗口自适应
			window.addEventListener('resize', function() {
				myChart.resize();
			});
		},
		error: function(xhr, status, error) {
			console.error("Age-Value data load failed: ", error);
			alert("Data load failed, please check backend service!");
		}
	});
}());

//  房价收入比分布和房屋年龄分布
// 左侧：房价收入比分布饼图
(function() {
	// 1. AJAX请求后端数据（从/page/api/houseBurden接口获取）
	$.ajax({
		url: "/page/api/houseBurden",
		type: "GET",
		dataType: "json",
		success: function(backendData) {
			// 2. 从后端返回的数组中提取需要的字段（level=等级，count=区域数）
			const burdenData = {
				// 提取等级名称（如："超轻负担(<0.5)"）
				levels: backendData.map(item => item.level),
				// 提取区域数（如：10516）
				counts: backendData.map(item => item.count),
				// 保留原有的颜色配置
				colors: ["#46F0FF", "#E6C146", "#D591FE", "#7689FF", "#FF6B6B"]
			};

			// 3. 原有样式配置（无需修改）
			const rich = {
				yellow: {
					color: "#ffc72b",
					fontSize: 18,
					padding: [2, 4],
					align: 'center'
				},
				white: {
					color: "#fff",
					align: 'center',
					fontSize: 16,
					padding: [5, 0]
				},
				blue: {
					color: '#49dff0',
					fontSize: 16,
					align: 'center'
				}
			};

			// 4. 初始化ECharts实例（绑定容器#left-bottom）
			const myLeftChart = echarts.init($("#left-bottom")[0]);

			// 5. 图表配置项（复用原有逻辑，仅替换数据来源）
			const leftOption = {
				tooltip: {
					trigger: 'item',
					formatter: params => `${params.name}<br>区域数：${params.value}<br>占比：${params.percent.toFixed(1)}%`,
					textStyle: { color: "#fff" },
					backgroundColor: "rgba(0, 20, 50, 0.8)"
				},
				legend: {
					data: burdenData.levels,
					bottom: 20,
					left: "20%",
					textStyle: { color: "#fff", fontSize: 12, fontWeight: "lighter" },
					itemGap: 15,
					itemWidth: 30,
					itemHeight: 12,
					orient: "horizontal"
				},
				series: [{
					type: 'pie',
					label: {
						normal: {
							color: "#fff",
							formatter: params => `{white|${params.name}}\n{yellow|${params.value}}\n{blue|${params.percent.toFixed(1)}%}`,
							padding: [0, 5],
							rich: rich,
							position: 'outside'
						}
					},
					labelLine: {
						lineStyle: { color: "#fff", width: 1.5 },
						length: 10,
						length2: 50,
						smooth: false,
					},
					center: ['60%', '50%'],
					radius: ['25%', '45%'],
					data: burdenData.levels.map((level, index) => ({
						value: burdenData.counts[index],
						itemStyle: { color: burdenData.colors[index] },
						name: level
					}))
				}]
			};

			// 6. 渲染图表
			myLeftChart.setOption(leftOption);

			// 7. 窗口自适应（窗口大小变化时图表自动调整）
			window.addEventListener('resize', () => myLeftChart.resize());
		},
		error: function(xhr, status, error) {
			// 请求失败时的提示
			console.error("房价负担数据加载失败：", error);
			alert("数据加载失败，请检查后端服务是否正常运行！");
		}
	});
})();

// 右侧：房屋年龄分布分析饼图
(function() {
	// 1. AJAX请求后端数据
	$.ajax({
		url: "/page/api/houseAge",
		type: "GET",
		dataType: "json",
		success: function(backendData) {
			// 2. 从后端数据提取前端所需字段
			const houseAgeData = {
				levels: backendData.map(item => item.ageLevel),  // 年龄分段
				counts: backendData.map(item => item.regionCount),// 区域数
				colors: ["#46F0FF", "#E6C146", "#D591FE", "#7689FF", "#FF6B6B"]
			};

			// 3. 原有ECharts配置
			const rich = {
				yellow: { color: "#ffc72b", fontSize: 18, align: 'center' },
				white: { color: "#fff", fontSize: 16, align: 'center' },
				blue: { color: '#49dff0', fontSize: 16, align: 'center' }
			};

			const myRightChart = echarts.init($("#right-bottom")[0]);
			$("#right-bottom").css({ width: "100%", height: "550px" });

			const rightOption = {
				tooltip: {
					trigger: 'item',
					formatter: params => `${params.name}<br>Region Count: ${params.value}<br>Percentage: ${params.percent.toFixed(1)}%`,
					textStyle: { color: "#fff" },
					backgroundColor: "rgba(0, 20, 50, 0.8)"
				},
				legend: {
					data: houseAgeData.levels,
					bottom: 20,
					left: "5%",
					right: "5%",
					textStyle: { color: "#fff", fontSize: 11, fontWeight: "lighter" }
				},
				series: [{
					type: 'pie',
					label: {
						normal: {
							formatter: params => `{white|${params.name}}\n{yellow|${params.value}}\n{blue|${params.percent.toFixed(1)}%}`,
							rich: rich,
							position: 'outside'
						}
					},
					labelLine: {
						lineStyle: { color: "#fff", width: 1.5 },
						length: 8,
						length2: 40,
					},
					center: ['45%', '50%'],
					radius: ['20%', '40%'],
					data: houseAgeData.levels.map((level, index) => ({
						value: houseAgeData.counts[index],
						itemStyle: { color: houseAgeData.colors[index] },
						name: level
					}))
				}]
			};

			myRightChart.setOption(rightOption);
			window.addEventListener('resize', () => myRightChart.resize());
		},
		error: function(xhr, status, error) {
			console.error("House Age data load failed: ", error);
			alert("Data load failed, please check backend service!");
		}
	});
})();
// 初始化布局（保留原有代码，无需修改）
$(document).ready(function() {
	$('.bodyLeftBottom.rel').css({
		'display': 'flex',
		'flex-direction': 'row',
		'justify-content': 'space-between'
	});

	$('.bodyLeftBottomLeft, .bodyRightBottomLeft').css({
		'float': 'none',
		'display': 'block'
	});

	setTimeout(() => {
		[document.getElementById('left-bottom'), document.getElementById('right-bottom')]
			.forEach(dom => {
				const chart = echarts.getInstanceByDom(dom);
				if (chart) chart.resize();
			});
	}, 100);

	window.addEventListener('resize', () => {
		[document.getElementById('left-bottom'), document.getElementById('right-bottom')]
			.forEach(dom => {
				const chart = echarts.getInstanceByDom(dom);
				if (chart) chart.resize();
			});
	});
});


// 入驻动态滚动（原有逻辑完整保留，无修改）
(function() {
	for (var i = 0; i < RZstatus.length; i++) {
		$(".huiYuanLst .moveul").html((index, html) => {
			return html += `<li><i></i><span>${RZstatus[i]}</span></li>`
		})
	}
	//获取实时数据后循环创建流水号滚动列表
	var siz1 = $(".huiYuanLst .moveul").find("li").length;
	$(".huiYuanLst .moveul").css('height', $(".huiYuanLst .moveul").find("li")[0].offsetHeight * 35);
	$(".huiYuanLst .moveul").html(function(index, value) {
		return value + value;
	})
	setInterval(function() {
		$(".huiYuanLst .moveul").animate({
			top: "-=35"
		}, 'slow', function() {
			if ($(".huiYuanLst .moveul")[0].offsetTop <= -siz1 * 35) {
				$(".huiYuanLst .moveul").css('top', 0);
			}
		})
	}, 5300)
}());



//入驻动态滚动
(function() {
	for (var i = 0; i < RZstatus.length; i++) {
		$(".huiYuanLst .moveul").html((index, html) => {
			return html += `<li><i></i><span>${RZstatus[i]}</span></li>`
		})
	}
	//获取实时数据后循环创建流水号滚动列表
	var siz1 = $(".huiYuanLst .moveul").find("li").length;
	$(".huiYuanLst .moveul").css('height', $(".huiYuanLst .moveul").find("li")[0].offsetHeight * 35);
	$(".huiYuanLst .moveul").html(function(index, value) {
		return value + value;
	})
	setInterval(function() {
		$(".huiYuanLst .moveul").animate({
			top: "-=35"
		}, 'slow', function() {
			if ($(".huiYuanLst .moveul")[0].offsetTop <= -siz1 * 35) {
				$(".huiYuanLst .moveul").css('top', 0);
			}
		})
	}, 5300)
}());


// 成交动态滚动
(function() {
	setInterval(function() {
		$(".liushuihaoul .moveul").animate({
			top: "-=50"
		}, 'slow', function() {
			if ($(".liushuihaoul .moveul")[0].offsetTop <= -siz2 * 50 + 10) {
				$(".liushuihaoul .moveul").css('top', 0);
			}
		})
	}, 5000)
}());



//消息动态滚动
(function() {
	//消息滚动
	for (var i = 0; i < callMsg.length; i++) {
		$(".call .moveul").html((index, html) => {
			return html += `<li><i></i><span>${callMsg[i]}</span></li>`
		})
	}
	var siz3 = Math.ceil($(".call .moveul").find("li").length / 3);
	$(".call .moveul").css('height', $(".call .moveul").find("li").length * 78);
	$(".call .moveul").html(function(index, value) {
		return value + value;
	})
	setInterval(function() {
		$(".call .moveul").animate({
			top: "-=78"
		}, 'slow', function() {
			if ($(".call .moveul")[0].offsetTop <= -siz3 * 78) {
				$(".call .moveul").css('top', 0);
			}
		})
	}, 8000)
}());



// 房屋市场综合评分仪表盘（动态获取后端数据）
(function() {
	// 1. AJAX请求后端数据
	$.ajax({
		url: "/page/api/marketScore",
		type: "GET",
		dataType: "json",
		success: function(backendData) {
			// 2. 适配数据格式（匹配前端仪表盘逻辑）
			var scoreData = []; // 改用var提升兼容性
			for (var i = 0; i < backendData.length; i++) {
				var item = backendData[i];
				scoreData.push({
					id: "yibiao" + (i + 1),
					name: item.indicatorName || "",
					maxScore: 100,
					score: item.score || 0,
					actualValue: item.actualValue || 0,
					desc: item.desc || ""
				});
			}

			// 3. 初始化仪表盘函数（适配原HTML的yibiao容器）
			function initGauge(indicator) {
				var myChart = echarts.init(document.getElementById(indicator.id));
				var option = {
					tooltip: {
						formatter: indicator.name + "<br>Score: {c} points<br>" + indicator.desc + ": " + indicator.actualValue
					},
					series: [{
						name: indicator.name,
						type: 'gauge',
						min: 0,
						max: indicator.maxScore,
						splitNumber: 10,
						radius: '100%',
						axisLine: {
							lineStyle: {
								color: [
									[0.6, '#BF4746'],
									[0.8, '#DE9B32'],
									[1, '#83B15A']
								],
								width: 10
							}
						},
						axisTick: {
							length: 15,
							lineStyle: { color: '#fff' }
						},
						splitLine: {
							length: 20,
							lineStyle: { color: '#fff', width: 2 }
						},
						axisLabel: {
							color: '#fff',
							fontSize: 12,
							textShadowColor: '#000'
						},
						title: {
							fontSize: 16,
							color: "#fff",
							offsetCenter: [0, '80%']
						},
						detail: {
							formatter: function(value) {
								return value + " points\n\n" + indicator.desc + "\n" + indicator.actualValue;
							},
							backgroundColor: '#1D2088',
							borderColor: '#00A0E9',
							borderWidth: 2,
							color: '#62D4FB',
							fontSize: 14,
							offsetCenter: [0, '40%']
						},
						data: [{ value: indicator.score, name: indicator.name }]
					}]
				};
				myChart.setOption(option);
				window.addEventListener('resize', function() {
					myChart.resize();
				});
				return myChart;
			}

			var charts = [];
			for (var j = 0; j < scoreData.length; j++) {
				charts.push(initGauge(scoreData[j]));
			}

			// 4. 初始化方块格子
			function initBlocks() {
				$(".huiyuan").each(function(index) {
					var indicator = scoreData[index];
					var blockCount = 10;
					var $blockList = $(this).find(".fangkuai");

					if ($blockList.find("li").length === 0) {
						for (var k = 0; k < blockCount; k++) {
							$blockList.append("<li></li>");
						}
					}

					$(this).find("span").text(indicator.score + " points (" + indicator.desc + ": " + indicator.actualValue + ")");
				});
			}

			// 5. 方块格子动画高亮特效（适配评分逻辑）
			function blockAnimation() {
				$(".huiyuan").each(function(index) {
					var indicator = scoreData[index];
					var $this = $(this);
					var t = 0;

					setInterval(function() {
						var activeBlocks = Math.floor(indicator.score / 10);
						// 避免除以0报错
						if (activeBlocks === 0) {
							$this.find(".fangkuai li").css("background", "#1D2088");
							return;
						}
						$this.find(".fangkuai li").each(function(i) {
							if (i < activeBlocks) {
								$(this).css("background", "#00A0E9");
								if (i === t) {
									$(this).css("background", "#FBED14");
								}
							} else {
								$(this).css("background", "#1D2088");
							}
						});
						t = (t + 1) % activeBlocks;
					}, 300);
				});
			}
			// 6. 执行初始化
			initBlocks();
			blockAnimation();
		},
		error: function(xhr, status, error) {
			console.error("Market score data load failed: ", error);
			alert("Data load failed, please check backend service!");
		}
	});
})();


//海拔与房价关系
(function() {
	// 1. AJAX请求后端数据
	$.ajax({
		url: "/page/api/latitudePrice",
		type: "GET",
		dataType: "json",
		success: function(backendData) {
			// 2. 从后端数据提取前端所需字段
			const latitudeData = {
				latitudeZones: backendData.map(item => item.latitudeZone),
				avgHouseValue: backendData.map(item => item.avgHouseValue),
				avgIncome: backendData.map(item => item.avgIncome)
			};
			// 3. 初始化echarts实例
			var myChart = echarts.init($("#jiage")[0]);
			// 4. 图表配置项
			var option = {
				textStyle: {
					color: "#fff",
					fontSize: 18,
					fontWeight: "lighter"
				},
				tooltip: {
					trigger: 'axis',
					textStyle: { color: "#fff" },
					backgroundColor: "rgba(0, 20, 50, 0.8)"
				},
				legend: {
					data: ['平均房屋价值', '平均居民收入'],
					top: 20,
					right: 20,
					itemGap: 20,
					textStyle: {
						color: "#fff",
						fontSize: "16"
					}
				},
				grid: {
					top: "15%",
					left: '8%',
					right: '5%',
					bottom: '10%',
					containLabel: true
				},
				color: ['#03A2E9', '#46B05D'],
				xAxis: {
					type: 'category',
					name: "California Latitude Zones",
					nameTextStyle: {
						color: "#fff",
						fontSize: "18"
					},
					data: latitudeData.latitudeZones,
					axisLine: {
						show: true,
						lineStyle: {
							color: "#fff",
							width: "2"
						},
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					},
					axisTick: {
						lineStyle: {
							color: "#fff",
							width: "2"
						}
					},
					axisLabel: {
						textStyle: {
							color: "#fff",
							fontSize: 14,
							interval: 0
						},
						rotate: 30
					}
				},
				yAxis: {
					type: 'value',
					min: 0,
					name: "指标数值",
					nameTextStyle: {
						color: "#fff",
						fontSize: "18"
					},
					axisLine: {
						show: true,
						lineStyle: {
							color: "#fff",
							width: "2"
						},
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					},
					splitLine: {
						show: true,
						lineStyle: {
							color: "#02416D",
							width: "0.5"
						}
					},
					axisLabel: {
						textStyle: {
							color: "#fff",
							fontSize: 14
						}
					}
				},
				series: [{
					name: '平均房屋价值',
					type: 'line',
					symbolSize: "8",
					itemStyle: {
						borderColor: "#03A2E9",
						borderWidth: 3
					},
					areaStyle: {
						color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
							offset: 0,
							color: 'rgba(3,160,230,.1)'
						}, {
							offset: 1,
							color: 'rgba(3,160,230,.3)'
						}])
					},
					smooth: false,
					data: latitudeData.avgHouseValue
				}, {
					name: '平均居民收入',
					type: 'line',
					symbolSize: "8",
					itemStyle: {
						borderColor: "#46B05D",
						borderWidth: 3
					},
					areaStyle: {
						color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
							offset: 0,
							color: 'rgba(62,155,93,.1)'
						}, {
							offset: 1,
							color: 'rgba(62,155,93,.3)'
						}])
					},
					smooth: false,
					data: latitudeData.avgIncome
				}]
			};

			// 5. 渲染图表
			myChart.setOption(option);
			// 6. 窗口自适应
			window.addEventListener('resize', function() {
				myChart.resize();
			});
		},
		error: function(xhr, status, error) {
			console.error("Latitude-Price data load failed: ", error);
			alert("Data load failed, please check backend service!");
		}
	});
}());

//区域人口规模分级
(function() {
	// 1. 初始化变量
	var echartdata = [0, 0, 0, 0]; // 初始数据（后端加载后替换）
	var rich = {
		yellow: {
			color: "#ffc72b",
			fontSize: 18,
			padding: [2, 4],
			align: 'center'
		},
		total: {
			color: "#ffc72b",
			fontSize: 20,
			align: 'center'
		},
		white: {
			color: "#fff",
			align: 'center',
			fontSize: 16,
			padding: [10, 0]
		},
		blue: {
			color: '#49dff0',
			fontSize: 16,
			align: 'center'
		},
		hr: {
			borderColor: 'auto',
			width: '100%',
			borderWidth: 1,
			height: 0,
		}
	};

	// 2. 初始化ECharts饼图
	var myChart = echarts.init($("#CJpie")[0]);
	var option = {
		tooltip: {
			trigger: 'item',
			formatter: "{b}: {c} ({d}%)"
		},
		series: [{
			type: 'pie',
			label: {
				fontSize: 24,
				normal: {
					color: "#fff",
					formatter: function(params, ticket, callback) {
						var total = echartdata.reduce((a, b) => a + b, 0);

						var percent = total === 0 ? 0.0 : ((params.value / total) * 100).toFixed(1);
						return '{white|' + params.name + '}\n\n{yellow|' + params.value + '}\n{blue|' + percent + '%}';
					},
					padding: [0, -20],
					rich: rich
				}
			},
			labelLine: {
				lineStyle: { width: 2 },
				length: 20,
				length2: 50
			},
			radius: ['25%', '50%'],
			data: [{
				value: echartdata[0],
				itemStyle: {
					color: new echarts.graphic.RadialGradient(.5, .5, 1, [{
						offset: 0,
						color: '#D068F8'
					}, {
						offset: 1,
						color: '#403CB6'
					}]),
				},
				name: '大型'
			}, {
				value: echartdata[1],
				itemStyle: {
					color: new echarts.graphic.RadialGradient(.5, .5, 2, [{
						offset: 0,
						color: '#08C6D8'
					}, {
						offset: 1,
						color: '#0D55A2'
					}]),
				},
				name: '中型'
			}, {
				value: echartdata[2],
				itemStyle: {
					color: new echarts.graphic.RadialGradient(0.5, 0.5, 2, [{
						offset: 0,
						color: '#3AF990'
					}, {
						offset: 1,
						color: '#036172'
					}]),
				},
				name: '小型'
			}, {
				value: echartdata[3],
				itemStyle: {
					color: new echarts.graphic.RadialGradient(0.5, 0.5, 2, [{
						offset: 0,
						color: '#FFF8A4'
					}, {
						offset: 1,
						color: '#FFEA02'
					}]),
				},
				name: '微型'
			}]
		}]
	};
	myChart.setOption(option);

	// 3. 初始化格子
	var totalGrid = 13;
	var gridValue = 200;
	$(".CJL .fangkuai").each(function() {
		$(this).empty();
		for (var i = 0; i < totalGrid; i++) {
			$(this).append("<li></li>");
		}
	});

	// 4. 渲染格子和数据（核心修改：取消微型黄色判断，统一使用蓝色#00A0E9）
	function run() {
		for (var i = 0; i < echartdata.length; i++) {
			var value = echartdata[i];
			var fillCount = Math.min(Math.ceil(value / gridValue), totalGrid);
			$(".CJL").eq(i).find("p").text(value);
			$(".CJL").eq(i).find(".fangkuai li").each(function(index) {
				var color = "#1D2088"; // 未点亮颜色
				// 移除 (i === 3) ? "#FBED14" : "#00A0E9" 判断，统一赋值为蓝色#00A0E9
				if (index >= (totalGrid - fillCount)) {
					color = "#00A0E9"; // 四个层级均使用蓝色点亮
				}
				$(this).css("background", color);
			});
		}
	}

	// 5. 实时数据更新方法
	function updateRealTimeData(newData) {
		if (!newData || newData.length !== 4) return;
		echartdata = newData;
		// 同步饼图数据
		option.series[0].data.forEach((item, idx) => item.value = echartdata[idx]);
		myChart.setOption(option, { notMerge: false, lazyUpdate: true });
		// 同步格子渲染
		run();
	}

	// 6. 格子闪烁动画（核心修改：取消微型黄色判断，统一蓝色+闪烁黄色高亮）
	var animationTimers = [];
	function initGridAnimation() {
		// 先清除已有定时器，防止动画叠加
		animationTimers.forEach(t => clearInterval(t));
		animationTimers = [];

		$(".CJL").each(function(index) {
			var t = totalGrid - 1;
			var _this = $(this);
			var timer = setInterval(function() {
				var value = echartdata[index];
				var fillCount = Math.min(Math.ceil(value / gridValue), totalGrid);
				var startIdx = totalGrid - fillCount;

				// 重置所有点亮格子为统一蓝色#00A0E9（四个层级一致）
				_this.find(".fangkuai li").each(function(i) {
					if (i >= startIdx) {
						$(this).css("background", "#00A0E9"); // 取消微型黄色，统一蓝色
					}
				});
				// 闪烁高亮仍保留黄色#FBED14（提升视觉效果，不影响层级统一）
				if (t >= startIdx) {
					_this.find(".fangkuai li").eq(t).css("background", "#FBED14");
				}
				t--;
				if (t < startIdx) t = totalGrid - 1;
			}, 300);
			animationTimers.push(timer);
		});
	}

	// 7. 从后端加载数据
	function loadDataFromBackend() {
		$.ajax({
			url: "/page/api/populationSize",
			type: "GET",
			dataType: "json",
			timeout: 5000, // 增加请求超时时间，防止无限等待
			success: function(backendData) {
				// 严格校验后端数据格式，避免异常数据导致前端崩溃
				if (!Array.isArray(backendData) || backendData.length !== 4) {
					console.warn("后端返回数据格式异常，忽略本次更新", backendData);
					return;
				}
				// 提取后端数据（按“大型→中型→小型→微型”顺序），确保数据为数字类型
				var newData = backendData.map(item => {
					var count = item && item.regionCount ? Number(item.regionCount) : 0;
					return isNaN(count) ? 0 : count;
				});
				// 更新数据并渲染
				updateRealTimeData(newData);
				// 重新初始化动画（确保数据更新后动画同步）
				initGridAnimation();
				console.log("✅ 区域人口规模数据加载完成:", newData);
			},
			error: function(xhr, status, error) {
				console.error("❌ Population size data load failed: ", status, error);
				// 仅提示错误，不中断轮询（后续仍会尝试获取）
			}
		});
	}

	// 8. 核心：实现定时轮询
	var pollInterval = 3000; // 轮询间隔
	var pollTimer = null; // 轮询定时器实例，便于后续清理

	// 启动轮询的方法
	function startPolling() {
		// 先清除已有定时器，防止重复创建
		if (pollTimer) clearInterval(pollTimer);
		// ① 页面加载时先获取一次初始数据（立即执行）
		loadDataFromBackend();
		// ② 定时轮询：每隔pollInterval毫秒拉取一次后端最新数据
		pollTimer = setInterval(function() {
			loadDataFromBackend();
		}, pollInterval);
	}

	// 停止轮询的方法
	function stopPolling() {
		if (pollTimer) {
			clearInterval(pollTimer);
			pollTimer = null;
		}

		animationTimers.forEach(t => clearInterval(t));
		animationTimers = [];
	}

	// 初始化启动轮询
	startPolling();

	// 9. 窗口自适应 + 页面卸载时清理所有资源（防止内存泄漏）
	$(window).resize(() => {
		if (myChart) myChart.resize();
	});

	// 页面卸载/关闭时，停止所有定时器和请求
	$(window).on("unload beforeunload", function() {
		stopPolling();
		// 销毁ECharts实例，释放DOM资源
		if (myChart) myChart.dispose();
	});

	// 暴露全局方法（便于手动控制轮询和更新数据）
	window.updateRegionData = updateRealTimeData;
	window.startPolling = startPolling;
	window.stopPolling = stopPolling;
})();



// 各纬度带房屋特征对比分析
(function() {
	// 1. AJAX请求后端数据
	$.ajax({
		url: "/page/api/latitudeFeature",
		type: "GET",
		dataType: "json",
		success: function(backendData) {
			// 2. 构造前端所需数据格式
			const latitudeData = {
				categories: backendData.map(item => item.latitudeGroup), // 纬度带名称
				seriesData: [
					{
						name: "平均房龄",
						data: backendData.map(item => item.avgHouseAge),
						color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [{
							offset: 0,
							color: '#3E3CB5'
						}, {
							offset: 1,
							color: '#D66BFD'
						}])
					},
					{
						name: "平均房间数",
						data: backendData.map(item => item.avgRooms),
						color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [{
							offset: 0,
							color: '#46F0FF'
						}, {
							offset: 1,
							color: '#00A0E9'
						}])
					},
					{
						name: "平均居住人数",
						data: backendData.map(item => item.avgOccupancy),
						color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [{
							offset: 0,
							color: '#FBED14'
						}, {
							offset: 1,
							color: '#DE9B32'
						}])
					}
				]
			};

			// 3. 初始化echarts实例
			const myChart = echarts.init($("#cjliang")[0]);

			// 4. 图表配置项
			const option = {
				grid: {
					left: "5%",
					right: "5%",
					bottom: "20%",
					top: "20%",
					containLabel: true
				},
				tooltip: {
					trigger: 'axis',
					axisPointer: { type: 'shadow' },
					formatter: params => {
						let res = `${params[0].name}<br>`;
						params.forEach(item => res += `${item.seriesName}：${item.value}<br>`);
						return res;
					},
					textStyle: { color: "#fff" }
				},
				legend: {
					data: latitudeData.seriesData.map(item => item.name),
					textStyle: { color: "#fff" },
					bottom: 10,
					left: "center"
				},
				xAxis: {
					type: 'category',
					data: latitudeData.categories,
					nameTextStyle: { color: "#fff", fontSize: 16 },
					axisTick: { lineStyle: { color: "#fff" } },
					axisLabel: { color: "#fff", fontSize: 16 },
					axisLine: {
						lineStyle: { color: "#fff", width: 2 },
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					}
				},
				yAxis: {
					type: 'value',
					name: "特征指标值",
					nameTextStyle: { color: "#fff", fontSize: 16 },
					axisLine: {
						lineStyle: { color: "#fff", width: 2 },
						symbol: ["none", "arrow"],
						symbolSize: [8, 20],
						symbolOffset: [0, 16]
					},
					axisTick: { lineStyle: { color: "#fff" } },
					axisLabel: { color: "#fff", fontSize: 16 },
					splitLine: {
						lineStyle: { color: "#02416D", width: 0.5 }
					}
				},
				series: latitudeData.seriesData.map(item => ({
					name: item.name,
					type: 'bar',
					barWidth: 30,
					label: {
						show: true,
						color: "#fff",
						fontSize: 14,
						position: "top"
					},
					itemStyle: { color: item.color },
					data: item.data
				}))
			};
			// 5. 渲染图表
			myChart.setOption(option);
			// 6. 窗口自适应
			window.addEventListener('resize', () => myChart.resize());
		},
		error: function(xhr, status, error) {
			console.error("Latitude-Feature data load failed: ", error);
			alert("Data load failed, please check backend service!");
		}
	});
})();



