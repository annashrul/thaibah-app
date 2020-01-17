import 'package:thaibah/Model/kecamatanModel.dart';
import 'package:thaibah/Model/kotaModel.dart';
import 'package:thaibah/Model/ongkirModel.dart';
import 'package:thaibah/Model/provinsiModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class ProvinsiBloc extends BaseBloc<ProvinsiModel>{
  Observable<ProvinsiModel> get allProvinsi => fetcher.stream;
  fetchProvinsiist() async {
    ProvinsiModel provinsi =  await repository.fetchAllProvinsi();
    fetcher.sink.add(provinsi);
  }
}

class KotaBloc extends BaseBloc<KotaModel>{
  Observable<KotaModel> get allKota => fetcher.stream;
  fetchKotaList(var idProv) async {
    KotaModel kota = await repository.fetchAllKota(idProv);
    fetcher.sink.add(kota);
  }
   clear() async {
    fetcher.sink.close();
  }
}
class KecamatanBloc extends BaseBloc<KecamatanModel>{
  Observable<KecamatanModel> get allKecamatan => fetcher.stream;
  fetchKecamatanList(var idKota) async {
    KecamatanModel kecamatan = await repository.fetchAllKecamatan(idKota);
    fetcher.sink.add(kecamatan);
  }
  clear() async {
    fetcher.sink.close();
  }
}

class OngkirBloc extends BaseBloc<OngkirModel>{
  Observable<OngkirModel> get allOngkir => fetcher.stream;
  fetchOngkirList(var dari, var ke, var berat, var kurir) async {
    OngkirModel ongkir = await repository.fetchAllOngkir(dari,ke,berat,kurir);
    fetcher.sink.add(ongkir);
  }
   clear() async {
    fetcher.sink.close();
  }
}



final provinsiBloc  = ProvinsiBloc();
final kotaBloc      = KotaBloc();
final kecamatanBloc = KecamatanBloc();
final ongkirBloc    = OngkirBloc();