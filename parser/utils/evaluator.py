import os
import subprocess
import torch
from ucca.convert import passage2file


def write_dev(dev_predicted, path):
    if not os.path.exists(path):
        try:
            os.makedirs(path)
        except Exception as e:
            print(e)

    for passage in dev_predicted:
        passage2file(passage, os.path.join(path, passage.ID + ".xml"))


class UCCA_Evaluator(object):
    def __init__(
        self, parser, gold_dev_dic=None, pred_dev_dic=None, temp_pred_dic=None
    ):
        self.parser = parser
        self.gold_dev_dic = gold_dev_dic
        self.pred_dev_dic = pred_dev_dic
        self.temp_pred_dic = temp_pred_dic
        self.best_F = 0

        if not os.path.exists(temp_pred_dic):
            try:
                os.makedirs(temp_pred_dic)
            except Exception as e:
                print(e)

    @torch.no_grad()
    def predict(self, loader):
        self.parser.eval()
        dev_predicted = []
        for batch in loader:
            word_idxs, char_idxs, passages, trees, all_nodes, all_remote = batch
            word_idxs = word_idxs.cuda() if torch.cuda.is_available() else word_idxs
            char_idxs = char_idxs.cuda() if torch.cuda.is_available() else char_idxs

            pred_passages = self.parser.parse(word_idxs, char_idxs, passages)
            dev_predicted.extend(pred_passages)
        return dev_predicted
        

    def compute_accuracy(self, dev):
        dev_predicted = self.predict(dev)
        write_dev(dev_predicted, self.temp_pred_dic)

        child = subprocess.Popen(
            "python -m scripts.evaluate_standard {} {} -f".format(
                self.gold_dev_dic, self.temp_pred_dic
            ),
            shell=True,
            stdout=subprocess.PIPE,
        )
        eval_info = str(child.communicate()[0], encoding="utf-8")
        try:
            Fscore = eval_info.strip().split("\n")[-1]
            Fscore = Fscore.strip().split()[-1]
            Fscore = float(Fscore)
            print("Fscore={}".format(Fscore))
        except IndexError:
            print("Unable to get FScore. Skipping.")
            Fscore = 0

        if Fscore > self.best_F:
            print(eval_info)
            self.best_F = Fscore
            write_dev(dev_predicted, self.pred_dev_dic)
        return Fscore