class CataBean {
  String cata;
  List<CataItem> cataItem;

  CataBean({this.cata, this.cataItem});

  CataBean.fromJson(Map<String, dynamic> json) {
    cata = json['cata'];
    if (json['CataItem'] != null) {
      cataItem = new List<CataItem>();
      json['CataItem'].forEach((v) {
        cataItem.add(new CataItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cata'] = this.cata;
    if (this.cataItem != null) {
      data['CataItem'] = this.cataItem.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CataItem {
  String name;
  String url;

  CataItem({this.name, this.url});

  CataItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}